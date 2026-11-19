#!/bin/bash

set -euo pipefail

pre-commit run --config .hooks/system/.pre-commit-config.yaml --hook-stage manual write-documentation --all-files
