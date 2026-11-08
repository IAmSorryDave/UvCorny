#!/bin/bash

LOG_DIR="$(pwd)/.build_logs"
LOG_FILE="$LOG_DIR/copilot-implementation-pytests.log"

mkdir -p "$LOG_DIR"

pre-commit run --hook-stage manual pytest --all-files 2>&1 | tee -a "$LOG_FILE"
