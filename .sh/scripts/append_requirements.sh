#!/bin/bash

## Have git ignore patch.
git update-index --skip-worktree ${PWD}/.pre-commit-config.yaml

## Add requirements flag
yq eval '(.. | select(has("id") and .id == "pytest") | .additional_dependencies) += ["-r"]' -i ${PWD}/.pre-commit-config.yaml

## Add absolute path of requirements file.
yq eval '(.. | select(has("id") and .id == "pytest") | .additional_dependencies) += [strenv(PWD) + "/requirements.txt"]' -i ${PWD}/.pre-commit-config.yaml

## Have git ignore patch.
git update-index --skip-worktree ${PWD}/.pre-commit-config.yaml
