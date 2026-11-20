#!/bin/bash
set -eu

source .scripts/bash/logs/setup/environment.bash

bash .scripts/bash/CI/manage_subagents.bash manage-subagents-scaffold

QA_WATCHER_PID=""

cleanup() {
  if [ -n "$QA_WATCHER_PID" ]; then
    kill "$QA_WATCHER_PID" 2>/dev/null || true
    wait "$QA_WATCHER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

bash .scripts/bash/CI/watch_aggregate_specification.bash &
QA_WATCHER_PID=$!

# bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-pm-workflow
python .scripts/python/scripts/manage_subagents.py run pm --workflow chat.bash

wait "$QA_WATCHER_PID"
