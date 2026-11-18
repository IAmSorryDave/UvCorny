#!/bin/bash

set -eu
set -o pipefail

source .scripts/bash/logs/setup/environment.bash
mkdir -p "$QA_STREAM_LOG_DIR"
mkdir -p "$QA_PYTEST_LOG_DIR"

if [ -z "$(git status --porcelain --untracked-files=all -- specification.yml)" ]; then
  echo "No Git changes detected in specification.yml; skipping QA workflow."
  exit 0
fi

bash "$(dirname "$0")/../subagent/subagent.bash" 2>&1 | tee -a "$QA_STREAM_LOG_FILE"
bash .scripts/bash/CI/test.bash 2>&1 | tee -a "$QA_PYTEST_LOG_FILE"
