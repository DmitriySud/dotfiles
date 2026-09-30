#!/usr/bin/env python3

import base64
import json
import subprocess
import sys
import time
from pathlib import Path


arguments = sys.argv[1:]
input_path = Path(arguments[arguments.index("--input") + 1])
output_path = Path(arguments[arguments.index("--output") + 1])
source = input_path.read_text(encoding="utf-8")
(input_path.parent / "arguments.json").write_text(
    json.dumps(arguments),
    encoding="utf-8",
)

if "INVALID" in source:
    print("synthetic Mermaid parse failure", file=sys.stderr)
    raise SystemExit(2)

if "SLEEP" in source:
    child = subprocess.Popen([sys.executable, "-c", "import time; time.sleep(60)"])
    (input_path.parent / "child.pid").write_text(str(child.pid), encoding="utf-8")
    time.sleep(60)

png = base64.b64decode(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
)
output_path.write_bytes(png)
