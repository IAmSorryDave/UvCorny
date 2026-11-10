#!/bin/bash

set -eu

LOG_DIR="$(pwd)/.build_logs"
LOG_FILE="$LOG_DIR/copilot-implementation-builds.log"

source .scripts/bash/copilot/setup/environment.bash

copilot \
   --available-tools='bash,edit,view,grep,glob' \
   --allow-tool='shell(bash main.bash),write(src/**),write(README.md.jinja),read(.build_logs/**)' \
   --deny-tool='write(src/**/__init__.py),write(src/**/_loader.py),write(test/**),write(.build_logs/**)' \
   2>&1 | tee -a "$LOG_FILE"
