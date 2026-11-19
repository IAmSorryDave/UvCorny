#!/bin/bash

source .scripts/bash/logs/setup/environment.bash

mkdir -p "$IMPLEMENTATION_PYTEST_LOG_DIR"
pre-commit run --config .hooks/system/.pre-commit-config.yaml --hook-stage manual pytest --all-files 2>&1 | tee -a "$IMPLEMENTATION_PYTEST_LOG_FILE"
