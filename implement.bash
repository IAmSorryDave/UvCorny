#!/bin/bash

README_TEMPLATE="README.md.jinja"
INITIAL_README_TEMPLATE_HASH="$(sha256sum "$README_TEMPLATE" 2>/dev/null | awk '{print $1}' || true)"

while ! bash main.bash || [ "$(sha256sum "$README_TEMPLATE" 2>/dev/null | awk '{print $1}' || true)" = "$INITIAL_README_TEMPLATE_HASH" ]; do
  bash .scripts/copilot/boot/constrained_loop_workflow.bash
done
