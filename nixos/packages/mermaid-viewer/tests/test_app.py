from __future__ import annotations

import argparse
import sys
import tempfile
import time
import unittest
from pathlib import Path
from unittest import mock


PACKAGE_DIR = Path(__file__).resolve().parents[1]
FIXTURES = Path(__file__).resolve().parent / "fixtures"
sys.path.insert(0, str(PACKAGE_DIR))

import app
import core
from gi.repository import Gio, GLib, Gtk


def drain_events() -> None:
    context = GLib.MainContext.default()
    while context.pending():
        context.iteration(False)


def wait_for(predicate: object, timeout: float = 3) -> None:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        drain_events()
        if predicate():
            return
        time.sleep(0.01)
    raise AssertionError("condition did not become true")


class ApplicationTest(unittest.TestCase):
    def setUp(self) -> None:
        self.save_directory = tempfile.TemporaryDirectory(prefix="mermaid saves ")
        self.arguments = argparse.Namespace(
            save_directory=Path(self.save_directory.name),
            width_fraction=0.25,
            render_timeout=2,
        )
        self.application = app.MermaidViewerApplication(self.arguments)
        self.assertTrue(self.application.register(None))
        self.application.activate()
        drain_events()
        self.renderer = FIXTURES / "fake_renderer.py"
        self.renderer.chmod(0o755)
        self.jobs: list[core.RenderJob] = []

    def tearDown(self) -> None:
        for window in list(self.application.get_windows()):
            window.destroy()
        for job in self.jobs:
            job.close()
        self.application.quit()
        drain_events()
        self.save_directory.cleanup()

    def job_factory(self, **kwargs: object) -> core.RenderJob:
        job = core.RenderJob(renderer=str(self.renderer), **kwargs)
        self.jobs.append(job)
        return job

    def set_source(self, editor: app.EditorWindow, source: str) -> None:
        editor.text_view.get_buffer().set_text(source)

    def test_success_replaces_editor_with_viewer_and_cleans_image_on_close(self) -> None:
        editor = self.application.editor
        self.assertIsInstance(editor, app.EditorWindow)
        self.set_source(editor, "flowchart LR\nA --> B")

        with (
            mock.patch("app.RenderJob", side_effect=self.job_factory),
            mock.patch("app.resize_viewer", return_value=True),
        ):
            self.application.start_render(editor)
            wait_for(
                lambda: any(
                    isinstance(window, app.ViewerWindow)
                    for window in self.application.get_windows()
                )
            )

        self.assertIsNone(self.application.editor)
        viewer = next(
            window
            for window in self.application.get_windows()
            if isinstance(window, app.ViewerWindow)
        )
        image_path = viewer.render_job.image_path
        self.assertTrue(image_path.exists())
        viewer.close()
        wait_for(lambda: not image_path.exists())

    def test_render_failure_restores_editor_and_preserves_source(self) -> None:
        editor = self.application.editor
        self.assertIsInstance(editor, app.EditorWindow)
        source = "INVALID MERMAID SOURCE"
        self.set_source(editor, source)

        with mock.patch("app.RenderJob", side_effect=self.job_factory):
            self.application.start_render(editor)
            wait_for(lambda: not self.application._rendering)

        self.assertTrue(editor.get_visible())
        self.assertEqual(editor.get_source(), source)
        self.assertTrue(editor.error_label.get_visible())
        self.assertIn("synthetic Mermaid parse failure", editor.error_label.get_text())

    def test_empty_input_stays_in_editor(self) -> None:
        editor = self.application.editor
        self.assertIsInstance(editor, app.EditorWindow)
        self.set_source(editor, "  \n")
        self.application.start_render(editor)
        self.assertTrue(editor.get_visible())
        self.assertTrue(editor.error_label.get_visible())

    def test_cancel_closes_editor(self) -> None:
        editor = self.application.editor
        self.assertIsInstance(editor, app.EditorWindow)
        editor.close()
        wait_for(lambda: self.application.editor is None)

    def test_application_allows_independent_invocations(self) -> None:
        self.assertTrue(
            self.application.get_flags() & Gio.ApplicationFlags.NON_UNIQUE
        )
        second = app.MermaidViewerApplication(self.arguments)
        self.assertTrue(second.register(None))
        second.activate()
        drain_events()
        self.assertIsNot(second.editor, self.application.editor)
        for window in list(second.get_windows()):
            window.destroy()
        second.quit()
        drain_events()


if __name__ == "__main__":
    unittest.main()
