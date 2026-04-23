#!/bin/sh

# Get the current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if branch is alpha
if [ "$BRANCH" = "main" ]; then
  # Delete the pytest hook from .pre-commit-config.yaml
  yq 'del(.repos[].hooks[] | select(.id == "pytest"))' -i .pre-commit-config.yaml
  echo "✓ Pytest hook removed from .pre-commit-config.yaml"
fi

uv tool install pre-commit --with pre-commit-uv --force-reinstall

pre-commit migrate-config

pre-commit install
