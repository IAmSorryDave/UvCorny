#!/bin/bash

set -o pipefail

pre-commit run --hook-stage manual pytest --all-files
