#!/bin/bash
set -eu

WORKFLOW="$1"
WATCH_DIR="$2"

# Match tests/<subdir>/test_*.py only.
# -mindepth 2 -maxdepth 2 skips top-level files in tests/ and
# any deeper nesting, so only files directly inside a subdirectory qualify.
if [[ -z "$(find "$WATCH_DIR" -mindepth 2 -maxdepth 2 -type f -name 'test_*.py' -print -quit 2>/dev/null)" ]]; then
  echo "[gate] No test_*.py files in a subdirectory of '$WATCH_DIR'; skipping workflow."
  exit 0
fi

source "$WORKFLOW"
