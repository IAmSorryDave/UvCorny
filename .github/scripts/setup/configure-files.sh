#!/bin/sh

# README.md should be refreshed on every pull / push.
if [ -f "README.md" ]; then rm README.md ; fi 

# Generate blank requiements.txt if none found. Required for pre-commit install. Subsequent uv-export hooks will update this file.
if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi

# Monkey patch .pre-commit-config.yaml

## Have git ignore patch.
git update-index --skip-worktree ${PWD}/.pre-commit-config.yaml

## Add requirements flag
yq eval '(.. | select(has("id") and .id == "pytest") | .additional_dependencies) += ["-r"]' -i ${PWD}/.pre-commit-config.yaml

## Add absolute path of requirements file.
yq eval '(.. | select(has("id") and .id == "pytest") | .additional_dependencies) += [strenv(PWD) + "/requirements.txt"]' -i ${PWD}/.pre-commit-config.yaml
