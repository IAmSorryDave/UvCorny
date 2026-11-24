#!/bin/bash

set -eu
set -o pipefail

bash .subagents/qa/subagent/subagent.bash 2>&1 | tee -a "$QA_STREAM_LOG_FILE"
bash .scripts/bash/CI/test.bash 2>&1 | tee -a "$QA_PYTEST_LOG_FILE"
