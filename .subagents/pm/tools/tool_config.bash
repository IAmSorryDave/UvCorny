read_tool_entries() {
  local file_path="$1"
  local destination_name="$2"
  local line
  local -n destination="$destination_name"

  if [[ ! -r "$file_path" ]]; then
    printf 'Tool configuration file is not readable: %s\n' "$file_path" >&2
    return 1
  fi

  destination=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" || "$line" == \#* ]] && continue
    destination+=("$line")
  done < "$file_path"
}

load_tool_config() {
  local tools_directory="$1"
  local available_tools
  local tool_rule

  read_tool_entries "$tools_directory/available-tools.txt" AVAILABLE_TOOLS
  read_tool_entries "$tools_directory/allowed-tools.txt" ALLOWED_TOOLS
  read_tool_entries "$tools_directory/disallowed-tools.txt" DISALLOWED_TOOLS

  COPILOT_TOOL_ARGUMENTS=()
  if ((${#AVAILABLE_TOOLS[@]})); then
    local IFS=,
    available_tools="${AVAILABLE_TOOLS[*]}"
    COPILOT_TOOL_ARGUMENTS+=(--available-tools="$available_tools")
  fi
  for tool_rule in "${ALLOWED_TOOLS[@]}"; do
    COPILOT_TOOL_ARGUMENTS+=(--allow-tool="$tool_rule")
  done
  for tool_rule in "${DISALLOWED_TOOLS[@]}"; do
    COPILOT_TOOL_ARGUMENTS+=(--deny-tool="$tool_rule")
  done
}
