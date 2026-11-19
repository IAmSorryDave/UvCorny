#!/bin/bash

set -eu

mkdir -p "$IMPLEMENTATION_STREAM_LOG_DIR"

while ! bash .scripts/bash/pre-commit/test.bash ; do
  while true; do
    if [ -n "$(git status --porcelain --untracked-files=all -- tests/)" ]; then
      source .subagents/implementation/subagent/subagent.bash 2>&1 | tee -a "$IMPLEMENTATION_STREAM_LOG_FILE"
      break
    else
      sleep 30
    fi
  done
done
