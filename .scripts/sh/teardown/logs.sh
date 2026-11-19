#!/bin/sh

set -eu

rm -rf -- \
  .subagents/implementation/logs/pytest \
  .subagents/implementation/logs/stream \
  .subagents/qa/logs/pytest \
  .subagents/qa/logs/stream \
  .subagents/pm/logs/chat \
  .subagents/pm/logs/stream
