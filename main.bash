#!/bin/bash
set -eu

WATCH_DIR="${1:-tests}"
WORKFLOW=".scripts/bash/copilot/boot/constrained_loop_workflow.bash"
GATE=".scripts/bash/copilot/boot/subdir_gate.bash"

source .scripts/bash/copilot/setup/environment.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- bash "$GATE" "$WORKFLOW" "$WATCH_DIR"
