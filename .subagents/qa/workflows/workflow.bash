#!/bin/bash

set -eu
set -o pipefail

source .scripts/bash/logs/setup/environment.bash
mkdir -p "$QA_STREAM_LOG_DIR"
mkdir -p "$QA_PYTEST_LOG_DIR"

QA_RUN_SCRIPT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/run.bash"

watchexec \
  --watch requirements/aggregate \
  --postpone \
  --on-busy-update queue \
  -- bash "$QA_RUN_SCRIPT"
