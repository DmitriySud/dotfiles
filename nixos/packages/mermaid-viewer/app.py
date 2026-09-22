#!/usr/bin/env python3

from __future__ import annotations

import argparse
import os
import signal
import sys
import threading
from pathlib import Path

import gi

gi.require_version("Gdk", "4.0")
gi.require_version("Gtk", "4.0")

from gi.repository import Gdk, Gio, GLib, Gtk

from hyprland import resize_viewer
from core import MermaidViewerError, RenderJob, copy_image, save_image


APPLICATION_ID = "io.github.dyusudakov.MermaidViewer"
EDITOR_TITLE = "Mermaid Viewer - Editor"
VIEWER_TITLE = "Mermaid Viewer - Image"


def parse_arguments(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Render Mermaid diagrams in a small GTK viewer.")
    parser.add_argument(
        "--save-directory",
        type=Path,
        default=Path.home() / "Pictures" / "mermaid",
        help="directory used by the Save image button (default: %(default)s)",
    )
    parser.add_argument(
        "--width-fraction",
        type=float,
        default=0.25,
        help="desired tiled viewer width as a monitor fraction (default: %(default)s)",
    )
    parser.add_argument(
        "--render-timeout",
        type=float,
        default=30,
        help="Mermaid CLI timeout in seconds (default: %(default)s)",
    )
    arguments = parser.parse_args(argv)
    if not 0 < arguments.width_fraction < 1:
        parser.error("--width-fraction must be greater than 0 and less than 1")
    if arguments.render_timeout <= 0:
        parser.error("--render-timeout must be greater than 0")
    return arguments


class EditorWindow(Gtk.ApplicationWindow):
    def __init__(self, application: "MermaidViewerApplication", source: str = "") -> None:
        super().__init__(application=application, title=EDITOR_TITLE)
        self.set_default_size(760, 520)

        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        root.set_margin_top(12)
        root.set_margin_bottom(12)
        root.set_margin_start(12)
        root.set_margin_end(12)
        self.set_child(root)

        self.error_label = Gtk.Label(xalign=0)
        self.error_label.set_wrap(True)
        self.error_label.add_css_class("error")
        self.error_label.set_visible(False)
        root.append(self.error_label)

        scroller = Gtk.ScrolledWindow(hexpand=True, vexpand=True)
        self.text_view = Gtk.TextView(monospace=True, wrap_mode=Gtk.WrapMode.NONE)
        self.text_view.get_buffer().set_text(source)
        scroller.set_child(self.text_view)
        root.append(scroller)

        actions = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        actions.set_halign(Gtk.Align.END)
        cancel_button = Gtk.Button(label="Cancel")
        cancel_button.connect("clicked", lambda _button: self.close())
        render_button = Gtk.Button(label="Render")
        render_button.add_css_class("suggested-action")
        render_button.connect("clicked", lambda _button: application.start_render(self))
        actions.append(cancel_button)
        actions.append(render_button)
        root.append(actions)

        shortcuts = Gtk.ShortcutController()
        shortcuts.add_shortcut(
            Gtk.Shortcut.new(
                Gtk.KeyvalTrigger.new(Gdk.KEY_Return, Gdk.ModifierType.CONTROL_MASK),
                Gtk.CallbackAction.new(lambda *_args: self._render_shortcut(application)),
            )
        )
        shortcuts.add_shortcut(
            Gtk.Shortcut.new(
                Gtk.KeyvalTrigger.new(Gdk.KEY_Escape, Gdk.ModifierType.NO_MODIFIER_MASK),
                Gtk.CallbackAction.new(lambda *_args: self._cancel_shortcut()),
            )
        )
        self.add_controller(shortcuts)
        self.connect("close-request", self._on_close)

    def _render_shortcut(self, application: "MermaidViewerApplication") -> bool:
        application.start_render(self)
        return True

    def _cancel_shortcut(self) -> bool:
        self.close()
        return True

    def _on_close(self, _window: Gtk.Window) -> bool:
        application = self.get_application()
        if isinstance(application, MermaidViewerApplication):
            application.cancel_editor(self)
        else:
            self.destroy()
        return True

    def get_source(self) -> str:
        buffer = self.text_view.get_buffer()
        return buffer.get_text(buffer.get_start_iter(), buffer.get_end_iter(), True)

    def show_error(self, message: str) -> None:
        self.error_label.set_text(message)
        self.error_label.set_visible(True)

    def focus_editor(self) -> bool:
        self.text_view.grab_focus()
        return GLib.SOURCE_REMOVE


class ViewerWindow(Gtk.ApplicationWindow):
    def __init__(
        self,
        application: "MermaidViewerApplication",
        render_job: RenderJob,
    ) -> None:
        super().__init__(application=application, title=VIEWER_TITLE)
        self.render_job = render_job
        self.zoom = 1.0

        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        root.set_margin_top(8)
        root.set_margin_bottom(8)
        root.set_margin_start(8)
        root.set_margin_end(8)
        self.set_child(root)

        texture = Gdk.Texture.new_from_filename(str(render_job.image_path))
        self.image_width = texture.get_width()
        self.image_height = texture.get_height()
        self.picture = Gtk.Picture.new_for_paintable(texture)
        self.picture.set_content_fit(Gtk.ContentFit.CONTAIN)
        self.picture.set_can_shrink(True)
        self.picture.set_hexpand(True)
        self.picture.set_vexpand(True)

        scroller = Gtk.ScrolledWindow(hexpand=True, vexpand=True)
        scroller.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroller.set_child(self.picture)
        root.append(scroller)

        controls = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        fit_button = Gtk.Button(label="Fit")
        fit_button.connect("clicked", lambda _button: self._fit())
        zoom_out_button = Gtk.Button(label="−")
        zoom_out_button.set_tooltip_text("Zoom out")
        zoom_out_button.connect("clicked", lambda _button: self._change_zoom(1 / 1.25))
        zoom_in_button = Gtk.Button(label="+")
        zoom_in_button.set_tooltip_text("Zoom in")
        zoom_in_button.connect("clicked", lambda _button: self._change_zoom(1.25))
        controls.append(fit_button)
        controls.append(zoom_out_button)
        controls.append(zoom_in_button)
        controls.append(Gtk.Box(hexpand=True))

        save_button = Gtk.Button(label="Save image")
        save_button.connect("clicked", lambda _button: self._save(application.save_directory))
        copy_button = Gtk.Button(label="Copy image")
        copy_button.add_css_class("suggested-action")
        copy_button.connect("clicked", lambda _button: self._copy())
        controls.append(save_button)
        controls.append(copy_button)
        root.append(controls)

        self.status_label = Gtk.Label(xalign=0)
        self.status_label.set_wrap(True)
        self.status_label.set_selectable(True)
        root.append(self.status_label)

        self.connect("close-request", self._on_close)

    def _fit(self) -> None:
        self.picture.set_can_shrink(True)
        self.picture.set_size_request(-1, -1)
        self.picture.set_hexpand(True)
        self.picture.set_vexpand(True)

    def _change_zoom(self, factor: float) -> None:
        self.zoom = min(8.0, max(0.1, self.zoom * factor))
        self.picture.set_can_shrink(False)
        self.picture.set_hexpand(False)
        self.picture.set_vexpand(False)
        self.picture.set_size_request(
            round(self.image_width * self.zoom),
            round(self.image_height * self.zoom),
        )

    def _save(self, save_directory: Path) -> None:
        try:
            destination = save_image(self.render_job.image_path, save_directory)
        except (OSError, MermaidViewerError) as error:
            self._set_status(str(error), is_error=True)
            return
        self._set_status(f"Saved to {destination}")

    def _copy(self) -> None:
        try:
            copy_image(self.render_job.image_path)
        except (OSError, MermaidViewerError) as error:
            self._set_status(str(error), is_error=True)
            return
        self._set_status("Copied image to the clipboard.")

    def _set_status(self, message: str, is_error: bool = False) -> None:
        self.status_label.set_text(message)
        if is_error:
            self.status_label.add_css_class("error")
        else:
            self.status_label.remove_css_class("error")

    def _on_close(self, _window: Gtk.Window) -> bool:
        self.render_job.close()
        application = self.get_application()
        if isinstance(application, MermaidViewerApplication):
            application.active_jobs.discard(self.render_job)
        return False


class MermaidViewerApplication(Gtk.Application):
    def __init__(self, arguments: argparse.Namespace) -> None:
        super().__init__(
            application_id=APPLICATION_ID,
            flags=Gio.ApplicationFlags.NON_UNIQUE,
        )
        self.save_directory = arguments.save_directory.expanduser()
        self.width_fraction = arguments.width_fraction
        self.render_timeout = arguments.render_timeout
        self.editor: EditorWindow | None = None
        self.active_jobs: set[RenderJob] = set()
        self._rendering = False

    def do_activate(self) -> None:
        if self.editor is None:
            self.editor = EditorWindow(self)
            self.editor.connect("destroy", self._editor_destroyed)
        self.editor.present()
        GLib.idle_add(self.editor.focus_editor)

    def start_render(self, editor: EditorWindow) -> None:
        if self._rendering:
            return

        source = editor.get_source()
        if not source.strip():
            editor.show_error("Enter a Mermaid diagram before rendering.")
            return

        job = RenderJob(source=source, timeout_seconds=self.render_timeout)
        self.active_jobs.add(job)
        self._rendering = True
        self.hold()
        editor.set_visible(False)

        thread = threading.Thread(
            target=self._render_worker,
            args=(editor, job),
            name="mermaid-render",
            daemon=True,
        )
        thread.start()

    def _render_worker(self, editor: EditorWindow, job: RenderJob) -> None:
        try:
            job.render()
        except Exception as error:
            GLib.idle_add(self._render_failed, editor, job, str(error))
            return
        GLib.idle_add(self._render_succeeded, editor, job)

    def _render_succeeded(self, editor: EditorWindow, job: RenderJob) -> bool:
        self._rendering = False
        if self.editor is editor:
            self.editor = None
        editor.destroy()
        viewer = ViewerWindow(self, job)
        viewer.set_default_size(720, 720)
        viewer.present()
        threading.Thread(
            target=resize_viewer,
            args=(os.getpid(), self.width_fraction),
            name="mermaid-viewer-resize",
            daemon=True,
        ).start()
        self.release()
        return GLib.SOURCE_REMOVE

    def _render_failed(
        self,
        editor: EditorWindow,
        job: RenderJob,
        message: str,
    ) -> bool:
        self._rendering = False
        self.active_jobs.discard(job)
        job.close()
        editor.show_error(message)
        editor.present()
        editor.focus_editor()
        self.release()
        return GLib.SOURCE_REMOVE

    def cancel_editor(self, editor: EditorWindow) -> None:
        if self.editor is editor:
            self.editor = None
        editor.destroy()

    def _editor_destroyed(self, editor: EditorWindow) -> None:
        if self.editor is editor:
            self.editor = None

    def do_shutdown(self) -> None:
        for job in list(self.active_jobs):
            job.close()
        self.active_jobs.clear()
        Gtk.Application.do_shutdown(self)


def main(argv: list[str] | None = None) -> int:
    arguments = parse_arguments(sys.argv[1:] if argv is None else argv)
    application = MermaidViewerApplication(arguments)

    def request_quit(_signum: int, _frame: object) -> None:
        GLib.idle_add(application.quit)

    signal.signal(signal.SIGTERM, request_quit)
    signal.signal(signal.SIGINT, request_quit)
    return application.run([sys.argv[0]])


if __name__ == "__main__":
    raise SystemExit(main())
