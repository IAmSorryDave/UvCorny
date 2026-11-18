#!/usr/bin/bash
set -euo pipefail

SUBAGENT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROLE_DIR="$(dirname "$SUBAGENT_DIR")"
INSTRUCTIONS_FILE="$ROLE_DIR/instructions/instructions.md"

source "$ROLE_DIR/tools/tool_config.bash"
load_tool_config "$ROLE_DIR/tools"

if [[ ! -r "$INSTRUCTIONS_FILE" ]]; then
  printf 'Instruction file is missing or unreadable: %s\n' "$INSTRUCTIONS_FILE" >&2
  exit 1
fi

if [[ "${1:-}" == "--chat" ]]; then
  shift
  exec copilot --agent=pm --no-custom-instructions \
    "${COPILOT_TOOL_ARGUMENTS[@]}" "$@"
fi

ROLE_INSTRUCTIONS="$(<"$INSTRUCTIONS_FILE")"
exec copilot --no-custom-instructions -p "$ROLE_INSTRUCTIONS" \
  "${COPILOT_TOOL_ARGUMENTS[@]}" "$@"