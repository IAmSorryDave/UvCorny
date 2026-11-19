#!/bin/bash
set -eu

WATCH_DIR="${1:?Usage: $0 <watch-directory>}"

# Match tests/<subdir>/test_*.py only.
# -mindepth 2 -maxdepth 2 skips top-level files in tests/ and
# any deeper nesting, so only files directly inside a subdirectory qualify.
if [[ -z "$(find "$WATCH_DIR" -mindepth 2 -maxdepth 2 -type f -name 'test_*.py' -print -quit 2>/dev/null)" ]]; then
  echo "[gate] No test_*.py files in a subdirectory of '$WATCH_DIR'; skipping workflow."
  exit 0
fi

bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-implementation-workflow