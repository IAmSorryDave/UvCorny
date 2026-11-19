#!/bin/bash

set -eu
set -o pipefail

source .scripts/bash/logs/setup/environment.bash
mkdir -p "$QA_STREAM_LOG_DIR"
mkdir -p "$QA_PYTEST_LOG_DIR"

SPECIFICATION_PATH="requirements/aggregate/specification.yml"
if ! git ls-files --error-unmatch "$SPECIFICATION_PATH" >/dev/null 2>&1; then
  echo "Aggregate specification is not tracked; skipping QA workflow."
  exit 0
fi

if ! git diff --quiet HEAD -- "$SPECIFICATION_PATH"; then
  echo "Aggregate specification has uncommitted changes; skipping QA workflow."
  exit 0
fi

bash "$(dirname "$0")/../subagent/subagent.bash" 2>&1 | tee -a "$QA_STREAM_LOG_FILE"
bash .scripts/bash/CI/test.bash 2>&1 | tee -a "$QA_PYTEST_LOG_FILE"
