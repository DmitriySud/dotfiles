from __future__ import annotations

import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path


PACKAGE_DIR = Path(__file__).resolve().parents[1]
FIXTURES = Path(__file__).resolve().parent / "fixtures"
sys.path.insert(0, str(PACKAGE_DIR))

from hyprland import resize_viewer


def result(value: object = None, return_code: int = 0) -> subprocess.CompletedProcess[str]:
    stdout = "" if value is None else json.dumps(value)
    return subprocess.CompletedProcess([], return_code, stdout, "")


class FakeRunner:
    def __init__(self, responses: list[subprocess.CompletedProcess[str] | Exception]) -> None:
        self.responses = responses
        self.arguments: list[list[str]] = []

    def __call__(self, arguments: list[str]) -> subprocess.CompletedProcess[str]:
        self.arguments.append(arguments)
        response = self.responses.pop(0)
        if isinstance(response, Exception):
            raise response
        return response


class ResizeViewerTest(unittest.TestCase):
    def setUp(self) -> None:
        self.clients = json.loads((FIXTURES / "clients.json").read_text(encoding="utf-8"))
        self.monitors = json.loads((FIXTURES / "monitors.json").read_text(encoding="utf-8"))

    def successful_runner(
        self,
        clients: list[dict[str, object]] | None = None,
        monitors: list[dict[str, object]] | None = None,
    ) -> FakeRunner:
        clients = copy.deepcopy(self.clients if clients is None else clients)
        monitors = copy.deepcopy(self.monitors if monitors is None else monitors)
        return FakeRunner(
            [
                result(clients),
                result(monitors),
                result(),
                result(clients),
                result(),
                result(),
            ]
        )

    def assert_left_split_ratio(self, monitor: dict[str, object]) -> None:
        clients = copy.deepcopy(self.clients)
        clients[0]["at"] = [monitor.get("x", 0), 0]
        clients[0]["size"] = [100, 100]
        runner = self.successful_runner(clients=clients, monitors=[monitor])
        self.assertTrue(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(
            runner.arguments[-1][2],
            'hl.dsp.layout("splitratio 0.5 exact")',
        )

    def test_scale_one(self) -> None:
        self.assert_left_split_ratio(
            {
                "id": 1,
                "x": 0,
                "width": 2560,
                "height": 1440,
                "scale": 1,
                "transform": 0,
            },
        )

    def test_scale_one_and_a_half(self) -> None:
        self.assert_left_split_ratio(
            {
                "id": 1,
                "x": 0,
                "width": 3840,
                "height": 2160,
                "scale": 1.5,
                "transform": 0,
            },
        )

    def test_scale_two(self) -> None:
        self.assert_left_split_ratio(
            {
                "id": 1,
                "x": 0,
                "width": 3840,
                "height": 2160,
                "scale": 2,
                "transform": 0,
            },
        )

    def test_rotated_monitor_uses_transformed_width(self) -> None:
        self.assert_left_split_ratio(
            {
                "id": 1,
                "x": 0,
                "width": 1920,
                "height": 1080,
                "scale": 1.5,
                "transform": 1,
            },
        )

    def test_uses_viewer_monitor_instead_of_focused_monitor(self) -> None:
        monitors = copy.deepcopy(self.monitors)
        monitors[0]["focused"] = True
        monitors[1]["focused"] = False
        runner = self.successful_runner(monitors=monitors)

        self.assertTrue(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))

        self.assertEqual(
            runner.arguments[-1][2],
            'hl.dsp.layout("splitratio 1.5 exact")',
        )

    def test_selects_process_from_multiple_viewers_even_if_focus_changes(self) -> None:
        clients = copy.deepcopy(self.clients)
        other = copy.deepcopy(clients[0])
        other["address"] = "0xother"
        other["pid"] = 99
        other["focusHistoryID"] = 0
        clients[0]["focusHistoryID"] = 10
        clients.insert(0, other)
        runner = self.successful_runner(clients=clients)

        self.assertTrue(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))

        self.assertIn("address:0xviewer", runner.arguments[-2][2])

    def test_waits_for_delayed_mapping(self) -> None:
        sleeps: list[float] = []
        runner = FakeRunner(
            [
                result([]),
                result([]),
                result(self.clients),
                result(self.monitors),
                result(),
                result(self.clients),
                result(),
                result(),
            ]
        )

        self.assertTrue(
            resize_viewer(100, 0.25, runner=runner, sleeper=sleeps.append)
        )
        self.assertEqual(len(sleeps), 2)

    def test_lone_viewer_keeps_normal_tiled_size(self) -> None:
        runner = FakeRunner([result([self.clients[0]])])
        self.assertTrue(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(len(runner.arguments), 1)

    def test_window_closed_before_resize_is_harmless(self) -> None:
        runner = FakeRunner(
            [result(self.clients), result(self.monitors), result(), result([])]
        )
        self.assertFalse(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(len(runner.arguments), 4)

    def test_malformed_refreshed_geometry_is_harmless(self) -> None:
        clients = copy.deepcopy(self.clients)
        clients[0]["at"] = []
        runner = FakeRunner(
            [result(self.clients), result(self.monitors), result(), result(clients)]
        )

        self.assertFalse(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(len(runner.arguments), 4)

    def test_missing_hyprland_is_harmless(self) -> None:
        runner = FakeRunner([FileNotFoundError("hyprctl")])
        self.assertFalse(
            resize_viewer(100, 0.25, attempts=1, runner=runner, sleeper=lambda _delay: None)
        )

    def test_failed_dispatch_does_not_attempt_resize(self) -> None:
        runner = FakeRunner(
            [result(self.clients), result(self.monitors), result(return_code=1)]
        )
        self.assertFalse(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(len(runner.arguments), 3)

    def test_uses_refreshed_side_after_moving_viewer_to_root(self) -> None:
        refreshed_clients = copy.deepcopy(self.clients)
        refreshed_clients[0]["at"] = [0, 0]
        runner = FakeRunner(
            [
                result(self.clients),
                result(self.monitors),
                result(),
                result(refreshed_clients),
                result(),
                result(),
            ]
        )

        self.assertTrue(resize_viewer(100, 0.25, runner=runner, sleeper=lambda _delay: None))
        self.assertEqual(
            runner.arguments[-1][2],
            'hl.dsp.layout("splitratio 0.5 exact")',
        )


if __name__ == "__main__":
    unittest.main()
