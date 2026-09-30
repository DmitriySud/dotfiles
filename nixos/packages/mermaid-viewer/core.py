from __future__ import annotations

import os
import shutil
import signal
import subprocess
import tempfile
import threading
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path


class MermaidViewerError(RuntimeError):
    pass


class EmptySourceError(MermaidViewerError):
    pass


class RenderError(MermaidViewerError):
    pass


class RenderTimeoutError(RenderError):
    pass


@dataclass(eq=False)
class RenderJob:
    source: str
    renderer: str = "mmdc"
    timeout_seconds: float = 30
    scale: int = 2
    puppeteer_config: str | None = field(
        default_factory=lambda: os.environ.get("MERMAID_VIEWER_PUPPETEER_CONFIG")
    )
    mermaid_config: str | None = field(
        default_factory=lambda: os.environ.get("MERMAID_VIEWER_CONFIG")
    )
    background: str = "white"
    temporary_directory: Path = field(init=False)
    source_path: Path = field(init=False)
    image_path: Path = field(init=False)
    _process: subprocess.Popen[bytes] | None = field(init=False, default=None)
    _process_lock: threading.Lock = field(init=False, default_factory=threading.Lock)

    def __post_init__(self) -> None:
        self.temporary_directory = Path(tempfile.mkdtemp(prefix="mermaid-viewer-"))
        self.source_path = self.temporary_directory / "diagram.mmd"
        self.image_path = self.temporary_directory / "diagram.png"

    def render(self) -> Path:
        if not self.source.strip():
            raise EmptySourceError("Enter a Mermaid diagram before rendering.")

        self.source_path.write_text(self.source, encoding="utf-8")
        command = [
            self.renderer,
            "--input",
            str(self.source_path),
            "--output",
            str(self.image_path),
            "--scale",
            str(self.scale),
            "--backgroundColor",
            self.background,
        ]
        if self.puppeteer_config:
            command.extend(["--puppeteerConfigFile", self.puppeteer_config])
        if self.mermaid_config:
            command.extend(["--configFile", self.mermaid_config])

        try:
            process = subprocess.Popen(
                command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                start_new_session=True,
            )
        except OSError as error:
            raise RenderError(f"Could not start Mermaid CLI: {error}") from error

        with self._process_lock:
            self._process = process

        try:
            _, stderr = process.communicate(timeout=self.timeout_seconds)
        except subprocess.TimeoutExpired as error:
            self._terminate_process_group(process)
            process.communicate()
            self.image_path.unlink(missing_ok=True)
            raise RenderTimeoutError(
                f"Mermaid rendering exceeded {self.timeout_seconds:g} seconds."
            ) from error
        finally:
            with self._process_lock:
                if self._process is process:
                    self._process = None

        if process.returncode != 0:
            self.image_path.unlink(missing_ok=True)
            detail = stderr.decode("utf-8", errors="replace").strip()
            message = "Mermaid CLI could not render this diagram."
            if detail:
                message = f"{message}\n\n{detail}"
            raise RenderError(message)

        if not self.image_path.is_file() or self.image_path.stat().st_size == 0:
            raise RenderError("Mermaid CLI completed without producing a PNG image.")

        return self.image_path

    def cancel(self) -> None:
        with self._process_lock:
            process = self._process
        if process is not None and process.poll() is None:
            self._terminate_process_group(process)

    def close(self) -> None:
        self.cancel()
        shutil.rmtree(self.temporary_directory, ignore_errors=True)

    @staticmethod
    def _terminate_process_group(process: subprocess.Popen[bytes]) -> None:
        try:
            os.killpg(process.pid, signal.SIGTERM)
            process.wait(timeout=1)
        except ProcessLookupError:
            return
        except subprocess.TimeoutExpired:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass


def save_image(image_path: Path, save_directory: Path) -> Path:
    save_directory.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")

    for suffix in range(1000):
        suffix_text = "" if suffix == 0 else f"-{suffix}"
        destination = save_directory / f"mermaid-{timestamp}{suffix_text}.png"
        try:
            with destination.open("xb") as output:
                with image_path.open("rb") as source:
                    shutil.copyfileobj(source, output)
            return destination
        except FileExistsError:
            continue

    raise MermaidViewerError("Could not choose an unused image filename.")


def copy_image(
    image_path: Path,
    clipboard_command: str = "wl-copy",
    timeout_seconds: float = 5,
) -> None:
    image_bytes = image_path.read_bytes()
    with tempfile.TemporaryFile() as error_file:
        try:
            process = subprocess.Popen(
                [clipboard_command, "--type", "image/png"],
                stdin=subprocess.PIPE,
                stdout=subprocess.DEVNULL,
                stderr=error_file,
                start_new_session=True,
            )
        except OSError as error:
            raise MermaidViewerError(f"Could not copy the image: {error}") from error

        try:
            if process.stdin is None:
                raise MermaidViewerError("Could not open the clipboard input stream.")
            process.stdin.write(image_bytes)
            process.stdin.close()
            return_code = process.wait(timeout=timeout_seconds)
        except BrokenPipeError:
            return_code = process.wait(timeout=timeout_seconds)
        except subprocess.TimeoutExpired as error:
            RenderJob._terminate_process_group(process)
            raise MermaidViewerError(
                f"Clipboard owner did not start within {timeout_seconds:g} seconds."
            ) from error

        if return_code != 0:
            error_file.seek(0)
            detail = error_file.read().decode("utf-8", errors="replace").strip()
            message = "Could not copy the image to the clipboard."
            if detail:
                message = f"{message} {detail}"
            raise MermaidViewerError(message)
