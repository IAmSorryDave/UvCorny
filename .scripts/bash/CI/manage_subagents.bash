#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <manual-hook-id>" >&2
  exit 2
fi

pre-commit run --config .hooks/system/.pre-commit-config.yaml --hook-stage manual "$1" --all-files
