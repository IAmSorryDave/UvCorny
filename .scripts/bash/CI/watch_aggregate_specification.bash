#!/usr/bin/bash

set -euo pipefail

SPECIFICATION_PATH="requirements/aggregate/specification.yml"
last_branch="$(git branch --show-current)"
last_commit="$(git rev-parse HEAD)"

commit_changes_specification() {
  local commit="$1"
  git diff-tree --root --no-commit-id --name-only -r -m "$commit" -- \
    "$SPECIFICATION_PATH" | grep -Fxq "$SPECIFICATION_PATH"
}

while sleep 1; do
  current_branch="$(git branch --show-current)"
  current_commit="$(git rev-parse HEAD)"

  if [[ "$current_branch" != "$last_branch" ]]; then
    last_branch="$current_branch"
    last_commit="$current_commit"
    continue
  fi

  if [[ "$current_commit" == "$last_commit" ]]; then
    continue
  fi

  if git merge-base --is-ancestor "$last_commit" "$current_commit"; then
    while IFS= read -r commit; do
      if commit_changes_specification "$commit"; then
        bash .subagents/qa/workflows/workflow.bash
      fi
    done < <(git rev-list --reverse "$last_commit..$current_commit")
  elif commit_changes_specification "$current_commit"; then
    bash .subagents/qa/workflows/workflow.bash
  fi

  last_commit="$current_commit"
done
