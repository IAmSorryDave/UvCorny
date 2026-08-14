#!/bin/sh

# Setup test directory, init file, and custom conftest.py.
if [ ! -d "tests" ]; then mkdir tests && touch tests/__init__.py && cp .python/templates/conftest.py tests/ ; fi

# Generate blank requiements.txt if none found. Required for pre-commit install. Subsequent uv-export hooks will update this file.
if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi

# Monkey patch .pre-commit-config.yaml
chmod +x scripts/pre-commit/append_requirements.bash && scripts/pre-commit/append_requirements.bash && chmod -x scripts/pre-commit/append_requirements.bash
