#!/bin/bash
set -eu

source .scripts/bash/logs/setup/environment.bash

WATCH_DIR="${1:-tests}"
WORKFLOW=".subagents/implementation/workflows/workflow.bash"
GATE=".subagents/implementation/gate/pytest_subdirectory_gate.bash"
QA_WORKFLOW=".subagents/qa/workflows/workflow.bash"

python .scripts/python/scripts/manage_subagents.py scaffold .

QA_WATCHER_PID=""
IMPLEMENTATION_WATCHER_PID=""

cleanup() {
  for watcher_pid in "$QA_WATCHER_PID" "$IMPLEMENTATION_WATCHER_PID"; do
    if [ -n "$watcher_pid" ]; then
      kill "$watcher_pid" 2>/dev/null || true
      wait "$watcher_pid" 2>/dev/null || true
    fi
  done
}
trap cleanup EXIT

watchexec \
  --watch-non-recursive . \
  --filter "/specification.yml" \
  --postpone \
  --debounce 2s \
  -- python .scripts/python/scripts/manage_subagents.py run qa \
  --workflow "$(basename "$QA_WORKFLOW")" &
QA_WATCHER_PID=$!

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- bash "$GATE" "$WORKFLOW" "$WATCH_DIR" &
IMPLEMENTATION_WATCHER_PID=$!

python .scripts/python/scripts/manage_subagents.py run pm \
  --workflow chat.bash

wait -n "$QA_WATCHER_PID" "$IMPLEMENTATION_WATCHER_PID"
