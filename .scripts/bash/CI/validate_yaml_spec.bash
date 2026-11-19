#!/bin/bash

set -euo pipefail

pre-commit run --config .hooks/system/.pre-commit-config.yaml --hook-stage manual validate-yaml-spec --all-files
