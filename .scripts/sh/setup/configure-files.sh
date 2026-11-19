#!/bin/sh

# Setup test directory, init file, and custom conftest.py.
if [ ! -d "tests" ]; then mkdir tests && touch tests/__init__.py && cp .scripts/python/templates/conftest.py tests/ ; fi

# Generate blank requiements.txt if none found. Required for pre-commit install. Subsequent uv-export hooks will update this file.
if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi

# Add project requirements to the framework-managed pytest hook.
chmod +x .scripts/bash/pre-commit/append_requirements.bash && .scripts/bash/pre-commit/append_requirements.bash && chmod -x .scripts/bash/pre-commit/append_requirements.bash
