#!/bin/sh

set -eu

branch_name="$(git branch --show-current)"
if [ -z "$branch_name" ]; then
  branch_name="detached-$(git rev-parse --short HEAD)"
fi

branch_slug="$(printf '%s' "$branch_name" | tr -c 'A-Za-z0-9._-' '-' | cut -c1-48)"
branch_hash="$(printf '%s' "$branch_name" | cksum | awk '{print $1}')"
branch_log_key="${branch_slug}-${branch_hash}"

mkdir -p \
  requirements/aggregate \
  "requirements/features/$branch_log_key" \
  "tests/$branch_log_key"
