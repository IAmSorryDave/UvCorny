#!/bin/bash
set -eu

WATCH_DIR="${1:-tests}"
WORKFLOW=".subagents/implementation/workflows/main_workflow.bash"
GATE=".subagents/implementation/gate/pytest_subdirectory_gate.bash"

source .scripts/bash/copilot/setup/environment.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- bash "$GATE" "$WORKFLOW" "$WATCH_DIR"
