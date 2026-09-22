#!/usr/bin/env python3

import os
import sys
from pathlib import Path


payload = sys.stdin.buffer.read()
if os.environ.get("FAKE_CLIPBOARD_FAIL"):
    print("synthetic clipboard failure", file=sys.stderr)
    raise SystemExit(7)

destination = os.environ.get("FAKE_CLIPBOARD_OUTPUT")
if destination:
    Path(destination).write_bytes(payload)
