#!/bin/sh

# README.md should be refreshed on every pull / push.
if [ -f "README.md" ]; then rm README.md ; fi 

# Generate blank requiements.txt if none found. Required for pre-commit install. Subsequent uv-export hooks will update this file.
if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi
