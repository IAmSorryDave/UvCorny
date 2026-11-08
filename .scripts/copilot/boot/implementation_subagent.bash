#!/bin/bash

PROMPT=$(tr '\n' ' ' < .github/copilot-instructions.md)

exec copilot -p "Files changed in ${WATCH_DIR}. ${PROMPT}" \
  --available-tools="bash,edit,view,grep,glob" \
  --allow-tool='shell(bash main.bash)' \
  --allow-tool='write(src/**)' \
  --allow-tool='write(README.md.jinja)' \
  --allow-tool='read(.build_logs/**)' \
  --allow-tool='read(.github/copilot-instructions.md)' \
  --allow-tool='read(README.md.jinja)' \
  --deny-tool='write(README.md)' \
  --deny-tool='write(src/**/__init__.py)' \
  --deny-tool='write(src/**/_loader.py)' \
  --deny-tool='write(tests/**)' \
  --deny-tool='write(.build_logs/**)'
