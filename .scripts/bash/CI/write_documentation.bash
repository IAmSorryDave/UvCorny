#!/bin/bash

set -euo pipefail

pre-commit run --hook-stage manual write-documentation --all-files
