#!/bin/bash

WATCH_DIR="${1:-tests}"
LOG_DIR="$(pwd)/.build_logs"
LOG_FILE="$LOG_DIR/copilot-implementation-builds.log"

mkdir -p "$LOG_DIR"

source .scripts/copilot/setup/environment.bash
export WATCH_DIR LOG_DIR

chmod +x .scripts/copilot/boot/implementation_subagent.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  --restart false \
  -- .scripts/copilot/boot/implementation_subagent.bash 2>&1 | tee -a "$LOG_FILE"

chmod -x .scripts/copilot/boot/implementation_subagent.bash
