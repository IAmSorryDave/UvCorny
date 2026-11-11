#!/bin/bash

source .scripts/bash/logs/setup/environment.bash

pre-commit run --hook-stage manual pytest --all-files 2>&1 | tee -a "$IMPLEMENTATION_PYTEST_LOG_FILE"
