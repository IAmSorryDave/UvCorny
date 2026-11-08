#!/bin/bash

set -eu

WATCH_DIR="${1:-tests}"
LOG_DIR="$(pwd)/.build_logs"
LOG_FILE="$LOG_DIR/copilot-implementation-builds.log"

mkdir -p "$LOG_DIR"

source .scripts/copilot/setup/environment.bash

chmod +x .scripts/copilot/boot/constrained_loop_workflow.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- .scripts/copilot/boot/constrained_loop_workflow.bash 2>&1 | tee -a "$LOG_FILE"

chmod -x .scripts/copilot/boot/constrained_loop_workflow.bash