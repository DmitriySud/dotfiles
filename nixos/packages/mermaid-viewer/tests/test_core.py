from __future__ import annotations

import json
import os
import shutil
import sys
import tempfile
import time
import unittest
from datetime import datetime
from pathlib import Path
from unittest import mock


PACKAGE_DIR = Path(__file__).resolve().parents[1]
FIXTURES = Path(__file__).resolve().parent / "fixtures"
sys.path.insert(0, str(PACKAGE_DIR))

from core import (
    EmptySourceError,
    MermaidViewerError,
    RenderError,
    RenderJob,
    RenderTimeoutError,
    copy_image,
    save_image,
)


class RenderJobTest(unittest.TestCase):
    def setUp(self) -> None:
        self.renderer = FIXTURES / "fake_renderer.py"
        self.renderer.chmod(0o755)
        self.jobs: list[RenderJob] = []

    def tearDown(self) -> None:
        for job in self.jobs:
            job.close()

    def make_job(self, source: str, **kwargs: object) -> RenderJob:
        job = RenderJob(source, renderer=str(self.renderer), **kwargs)
        self.jobs.append(job)
        return job

    def test_renders_png_and_writes_utf8_source(self) -> None:
        source = "flowchart LR\nA[Привет] --> B"
        job = self.make_job(source)

        result = job.render()

        self.assertEqual(result.read_bytes()[:8], b"\x89PNG\r\n\x1a\n")
        self.assertEqual(job.source_path.read_text(encoding="utf-8"), source)

    def test_passes_global_mermaid_config_to_renderer(self) -> None:
        config_path = FIXTURES / "mermaid-config.json"
        with mock.patch.dict(
            os.environ,
            {"MERMAID_VIEWER_CONFIG": str(config_path)},
            clear=False,
        ):
            job = self.make_job("flowchart LR\nA --> B")

        job.render()

        arguments = json.loads(
            (job.temporary_directory / "arguments.json").read_text(encoding="utf-8")
        )
        config_index = arguments.index("--configFile")
        self.assertEqual(arguments[config_index + 1], str(config_path))

    def test_rejects_empty_source(self) -> None:
        job = self.make_job(" \n\t")
        with self.assertRaises(EmptySourceError):
            job.render()

    def test_reports_renderer_error_and_removes_partial_output(self) -> None:
        job = self.make_job((FIXTURES / "invalid.mmd").read_text(encoding="utf-8"))

        with self.assertRaisesRegex(RenderError, "synthetic Mermaid parse failure"):
            job.render()

        self.assertFalse(job.image_path.exists())

    def test_timeout_kills_renderer_child_process(self) -> None:
        job = self.make_job("SLEEP", timeout_seconds=0.2)

        with self.assertRaises(RenderTimeoutError):
            job.render()

        child_pid = int((job.temporary_directory / "child.pid").read_text(encoding="utf-8"))
        deadline = time.monotonic() + 2
        while time.monotonic() < deadline and Path(f"/proc/{child_pid}").exists():
            stat = Path(f"/proc/{child_pid}/stat")
            if stat.exists() and stat.read_text(encoding="utf-8").split()[2] == "Z":
                break
            time.sleep(0.02)
        if Path(f"/proc/{child_pid}").exists():
            state = Path(f"/proc/{child_pid}/stat").read_text(encoding="utf-8").split()[2]
            self.assertEqual(state, "Z")

    def test_jobs_use_independent_temporary_directories(self) -> None:
        first = self.make_job("flowchart LR\nA --> B")
        second = self.make_job("sequenceDiagram\nA->>B: Hello")
        self.assertNotEqual(first.temporary_directory, second.temporary_directory)

    def test_renderer_path_may_contain_spaces(self) -> None:
        with tempfile.TemporaryDirectory(prefix="renderer path ") as directory:
            renderer = Path(directory) / "fake renderer"
            shutil.copy2(self.renderer, renderer)
            renderer.chmod(0o755)
            job = RenderJob("flowchart LR\nA --> B", renderer=str(renderer))
            self.jobs.append(job)
            self.assertTrue(job.render().is_file())


class ExportTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary_directory = tempfile.TemporaryDirectory(prefix="export test ")
        self.root = Path(self.temporary_directory.name)
        self.image = self.root / "source image.png"
        self.image.write_bytes(b"png payload")
        self.clipboard = FIXTURES / "fake_clipboard.py"
        self.clipboard.chmod(0o755)

    def tearDown(self) -> None:
        self.temporary_directory.cleanup()

    def test_save_creates_directory_and_preserves_bytes(self) -> None:
        destination = save_image(self.image, self.root / "directory with spaces")
        self.assertEqual(destination.read_bytes(), self.image.read_bytes())

    def test_save_uses_collision_suffix_without_overwriting(self) -> None:
        fixed = datetime(2026, 9, 22, 12, 0, 0, 123456)
        save_directory = self.root / "saved"
        save_directory.mkdir()
        existing = save_directory / "mermaid-20260922-120000-123456.png"
        existing.write_bytes(b"keep me")

        with mock.patch("core.datetime") as mocked_datetime:
            mocked_datetime.now.return_value = fixed
            destination = save_image(self.image, save_directory)

        self.assertEqual(existing.read_bytes(), b"keep me")
        self.assertEqual(destination.name, "mermaid-20260922-120000-123456-1.png")

    def test_copy_passes_png_bytes(self) -> None:
        destination = self.root / "clipboard payload.png"
        with mock.patch.dict(os.environ, {"FAKE_CLIPBOARD_OUTPUT": str(destination)}, clear=False):
            copy_image(self.image, clipboard_command=str(self.clipboard))
        self.assertEqual(destination.read_bytes(), self.image.read_bytes())

    def test_copy_reports_command_failure(self) -> None:
        with mock.patch.dict(os.environ, {"FAKE_CLIPBOARD_FAIL": "1"}, clear=False):
            with self.assertRaisesRegex(MermaidViewerError, "synthetic clipboard failure"):
                copy_image(self.image, clipboard_command=str(self.clipboard))


if __name__ == "__main__":
    unittest.main()
