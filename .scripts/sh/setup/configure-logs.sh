#!/bin/sh

. .scripts/bash/logs/setup/environment.bash

mkdir -p \
  "$IMPLEMENTATION_PYTEST_LOG_DIR" \
  "$IMPLEMENTATION_STREAM_LOG_DIR" \
  "$QA_PYTEST_LOG_DIR" \
  "$QA_STREAM_LOG_DIR" \
  "$PM_CHAT_LOG_DIR" \
  "$PM_STREAM_LOG_DIR"
