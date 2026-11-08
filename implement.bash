#!/bin/bash

set -eu

WATCH_DIR="${1:-tests}"

source .scripts/copilot/setup/environment.bash

chmod +x .scripts/copilot/boot/constrained_loop_workflow.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- .scripts/copilot/boot/constrained_loop_workflow.bash

chmod -x .scripts/copilot/boot/constrained_loop_workflow.bash