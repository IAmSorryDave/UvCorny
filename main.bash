#!/bin/bash
set -eu

source .scripts/bash/logs/setup/environment.bash

WATCH_DIR="${1:-tests}"
GATE=".subagents/implementation/gate/pytest_subdirectory_gate.bash"

bash .scripts/bash/CI/manage_subagents.bash manage-subagents-scaffold

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
  -- bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-qa-workflow &
QA_WATCHER_PID=$!

watchexec \
  --watch "$WATCH_DIR" \
  --exts py \
  --ignore "**/__init__.py" \
  --ignore "**/conftest.py" \
  --debounce 2s \
  -- bash "$GATE" "$WATCH_DIR" &
IMPLEMENTATION_WATCHER_PID=$!

bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-pm-workflow

wait -n "$QA_WATCHER_PID" "$IMPLEMENTATION_WATCHER_PID"
