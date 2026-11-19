#!/bin/bash

set -eu
set -o pipefail

source .scripts/bash/logs/setup/environment.bash
mkdir -p "$QA_STREAM_LOG_DIR"
mkdir -p "$QA_PYTEST_LOG_DIR"

if [ -z "$(git status --porcelain --untracked-files=all -- requirements/features/)" ]; then
  echo "No Git changes detected in feature specifications; skipping QA workflow."
  exit 0
fi

bash .scripts/bash/CI/validate_yaml_spec.bash
bash "$(dirname "$0")/../subagent/subagent.bash" 2>&1 | tee -a "$QA_STREAM_LOG_FILE"
bash .scripts/bash/CI/test.bash 2>&1 | tee -a "$QA_PYTEST_LOG_FILE"
