#!/bin/sh

set -eu

rm -rf -- .logs/implementation/pytest .logs/implementation/stream
rmdir .logs/implementation .logs 2>/dev/null || true
