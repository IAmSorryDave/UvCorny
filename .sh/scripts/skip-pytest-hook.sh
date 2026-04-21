#!/bin/sh

BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT_MSG="$1"

# List of branches where you want to skip pytest
SKIP_BRANCHES="main"

if echo "$BRANCH" | grep -qE "$SKIP_BRANCHES"; then
    SKIP=pytest git commit -m "$COMMIT_MSG"
else
    git commit -m "$COMMIT_MSG"
fi
