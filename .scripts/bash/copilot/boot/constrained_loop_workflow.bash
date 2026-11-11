#!/bin/bash

set -eu

source .scripts/bash/logs/setup/environment.bash

README_TEMPLATE="README.md.jinja"
[ -f "$README_TEMPLATE" ] || { echo "missing $README_TEMPLATE" >&2; exit 1; }
[ -f .github/copilot-instructions.md ] || { echo "missing copilot-instructions.md" >&2; exit 1; }

INITIAL_README_TEMPLATE_HASH="$(sha256sum "$README_TEMPLATE" | awk '{print $1}')"
WATCH_DIR="${1:-tests}"
PROMPT="$(tr '\n' ' ' < .github/copilot-instructions.md)"

export PROMPT WATCH_DIR

while ! bash .scripts/bash/pre-commit/test.bash || [ "$(sha256sum "$README_TEMPLATE" | awk '{print $1}')" = "$INITIAL_README_TEMPLATE_HASH" ]; do
  source .scripts/bash/copilot/boot/implementation_subagent.bash 2>&1 | tee -a "$IMPLEMENTATION_STREAM_LOG_FILE"
done
