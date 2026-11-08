#!/bin/bash

set -eu

README_TEMPLATE="README.md.jinja"
INITIAL_README_TEMPLATE_HASH="$(sha256sum "$README_TEMPLATE" 2>/dev/null | awk '{print $1}' || true)"
WATCH_DIR="${1:-tests}"
PROMPT=$(tr '\n' ' ' < .github/copilot-instructions.md)

export PROMPT WATCH_DIR

while ! bash main.bash ; do
  source .scripts/copilot/boot/implementation_subagent.bash
done

while [ "$(sha256sum "$README_TEMPLATE" 2>/dev/null | awk '{print $1}' || true)" = "$INITIAL_README_TEMPLATE_HASH" ]; do
  source .scripts/copilot/boot/implementation_subagent.bash
done