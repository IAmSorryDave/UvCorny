#!/bin/bash
set -eu

WATCH_DIR="${1:-tests}"
WORKFLOW=".scripts/copilot/boot/constrained_loop_workflow.bash"
GATE=".scripts/copilot/boot/subdir_gate.bash"

source .scripts/copilot/setup/environment.bash

chmod +x "$WORKFLOW" "$GATE"
trap 'chmod -x "$WORKFLOW" "$GATE"' EXIT

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- "$GATE" "$WORKFLOW" "$WATCH_DIR"
