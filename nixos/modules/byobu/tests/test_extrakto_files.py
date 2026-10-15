import os
from pathlib import Path
import tempfile
import unittest
from unittest import mock

from extrakto_files import capture_files, get_files


class FilesTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.cwd = Path(temporary.name)
        for name in ("README.md", "Makefile", ".env", "a", "sub/file.py", "file with spaces.txt", "literal."):
            path = self.cwd / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.touch()

    def test_absolute_relative_and_bare_filenames(self):
        absolute = str(self.cwd / "sub/file.py")
        text = f"Open {absolute} or ./README.md sub/file.py Makefile .env a"
        self.assertEqual(
            get_files(text, self.cwd),
            [absolute, "./README.md", "sub/file.py", "Makefile", ".env", "a"],
        )

    def test_prose_missing_paths_directories_and_urls_are_excluded(self):
        text = "ordinary words missing.txt missing/file.py sub https://example.com/README.md"
        self.assertEqual(get_files(text, self.cwd), [])

    def test_duplicate_files_follow_their_lowest_screen_occurrence(self):
        text = "README.md\nMakefile\nREADME.md\n.env\nMakefile\n"
        self.assertEqual(get_files(text, self.cwd), ["README.md", ".env", "Makefile"])

    def test_quotes_escaped_spaces_punctuation_and_source_locations(self):
        text = r'''"file with spaces.txt" file\ with\ spaces.txt `README.md` (sub/file.py:12:3), Makefile. literal.'''
        self.assertEqual(
            get_files(text, self.cwd),
            ["file with spaces.txt", "README.md", "sub/file.py", "Makefile", "literal."],
        )

    def test_tilde_paths_preserve_spelling(self):
        with mock.patch.dict(os.environ, {"HOME": str(self.cwd)}):
            self.assertEqual(get_files("~/README.md", self.cwd), ["~/README.md"])

    def test_uses_source_cwd_instead_of_process_cwd(self):
        self.assertEqual(get_files("README.md", self.cwd / "sub"), [])
        self.assertEqual(get_files("../README.md", self.cwd / "sub"), ["../README.md"])

    def test_shell_metacharacters_are_never_executed(self):
        text = f"$(touch {self.cwd}/executed) `touch {self.cwd}/executed`"
        self.assertEqual(get_files(text, self.cwd), [])
        self.assertFalse((self.cwd / "executed").exists())

    def test_symlinks_follow_files_but_exclude_directories_and_missing_targets(self):
        (self.cwd / "file-link").symlink_to(self.cwd / "README.md")
        (self.cwd / "dir-link").symlink_to(self.cwd / "sub")
        (self.cwd / "missing-link").symlink_to(self.cwd / "missing")
        self.assertEqual(get_files("file-link dir-link missing-link", self.cwd), ["file-link"])

    def test_window_capture_resolves_each_panes_cwd_and_excludes_picker(self):
        other = self.cwd / "other"
        other.mkdir()
        (other / "second.txt").touch()
        outputs = {
            ("list-panes", "-t", "%1", "-F", "#{pane_active} #{pane_id}"): "0 %1\n0 %2\n1 %3\n",
            ("display-message", "-p", "-t", "%1", "#{pane_current_path}"): f"{self.cwd}\n",
            ("display-message", "-p", "-t", "%2", "#{pane_current_path}"): f"{other}\n",
            ("capture-pane", "-pJS", "-10", "-t", "%1"): "README.md second.txt\n",
            ("capture-pane", "-pJS", "-10", "-t", "%2"): "second.txt README.md\n",
        }
        with mock.patch("extrakto_files.subprocess.check_output", side_effect=lambda cmd, **kwargs: outputs[tuple(cmd[1:])]):
            self.assertEqual(capture_files("%1", "window recent", "-10"), "README.md\nsecond.txt")


if __name__ == "__main__":
    unittest.main()
