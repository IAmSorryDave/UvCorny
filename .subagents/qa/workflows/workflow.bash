#!/bin/bash

set -eu
set -o pipefail

source .scripts/bash/logs/setup/environment.bash
mkdir -p "$QA_STREAM_LOG_DIR"

bash "$(dirname "$0")/../subagent/subagent.bash" "$@" 2>&1 | tee -a "$QA_STREAM_LOG_FILE"
