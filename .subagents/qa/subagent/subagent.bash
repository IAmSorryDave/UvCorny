#!/bin/bash

set -eu

SUBAGENT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROLE_DIR="$(dirname "$SUBAGENT_DIR")"
source "$ROLE_DIR/tools/tool_config.bash"
load_tool_config "$ROLE_DIR/tools"

: "${PROMPT:?Set PROMPT before starting this subagent}"
copilot -p "$PROMPT" "${COPILOT_TOOL_ARGUMENTS[@]}"
