#!/bin/bash

set -eu

WATCH_DIR="${1:-test}"
LOG_DIR="$(pwd)/.build_logs"
LOG_FILE="$LOG_DIR/copilot-implementaion-builds.log"
PROMPT="$(cat .github/copilot-instructions.md)"

source .scripts/copilot/setup/environment.bash

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  --restart false \
  -- copilot -p "Files changed in $WATCH_DIR. $PROMPT" \
   --available-tools='bash,edit,view,grep,glob' \
   --allow-tool='shell(bash main.bash),write(src/**),write(README.md.jinja),read(.build_logs/**)' \
   --deny-tool='write(src/**/__init__.py),write(src/**/_loader.py),write(test/**),write(.build_logs/**)' \
   2>&1 | tee -a "$LOG_FILE"

