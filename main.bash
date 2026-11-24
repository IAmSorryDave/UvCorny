#!/bin/bash
set -eu

QA_WORKFLOW_PID=""

cleanup() {
  if [ -n "$QA_WORKFLOW_PID" ]; then
    kill "$QA_WORKFLOW_PID" 2>/dev/null || true
    wait "$QA_WORKFLOW_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-qa-workflow &
QA_WORKFLOW_PID=$!

wait "$QA_WORKFLOW_PID"
