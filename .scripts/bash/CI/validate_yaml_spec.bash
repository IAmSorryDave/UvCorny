#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$PROJECT_ROOT"

mapfile -d '' -t FEATURE_SPECS < <(
  find requirements/features -mindepth 2 -maxdepth 2 -type f -name specification.yml -print0
)

if ((${#FEATURE_SPECS[@]})); then
  pre-commit run --config .hooks/system/.pre-commit-config.yaml \
    --hook-stage manual validate-yaml-spec --files "${FEATURE_SPECS[@]}"
else
  pre-commit run --config .hooks/system/.pre-commit-config.yaml \
    --hook-stage manual validate-yaml-spec --all-files
fi
