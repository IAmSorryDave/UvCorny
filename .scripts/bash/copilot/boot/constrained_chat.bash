#!/bin/bash

set -eu

source .scripts/bash/logs/setup/environment.bash

source .scripts/bash/copilot/setup/environment.bash

copilot \
   --available-tools='bash,edit,view,grep,glob' \
   --allow-tool='shell(bash main.bash),write(src/**),write(README.md.jinja),read(.logs/**)' \
   --deny-tool='write(src/**/__init__.py),write(src/**/_loader.py),write(test/**),write(.logs/**)' \
   2>&1 | tee -a "$IMPLEMENTATION_BUILD_LOG_FILE"
