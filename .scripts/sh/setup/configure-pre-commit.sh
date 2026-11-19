#!/bin/sh

uv tool install pre-commit --with pre-commit-uv --force-reinstall

pre-commit migrate-config --config .hooks/system/.pre-commit-config.yaml

pre-commit install --config .hooks/system/.pre-commit-config.yaml
