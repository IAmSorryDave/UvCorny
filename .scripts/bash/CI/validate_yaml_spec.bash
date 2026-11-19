#!/bin/bash

set -euo pipefail

pre-commit run --hook-stage manual validate-yaml-spec --all-files
