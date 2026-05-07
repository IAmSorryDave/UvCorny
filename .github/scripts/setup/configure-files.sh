#!/bin/sh

# Setup test directory, init file, and custom conftest.py.
mkdir tests && touch tests/__init__.py &&

# Generate blank requiements.txt if none found. Required for pre-commit install. Subsequent uv-export hooks will update this file.
if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi

# Monkey patch .pre-commit-config.yaml
chmod +x .sh/scripts/append_requirements.sh && .sh/scripts/append_requirements.sh && chmod -x .sh/scripts/append_requirements.sh
