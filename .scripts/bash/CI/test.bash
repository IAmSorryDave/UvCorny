#!/bin/bash

set -euo pipefail

pre-commit run --hook-stage manual pytest --all-files
