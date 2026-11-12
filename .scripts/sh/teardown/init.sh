#!/bin/sh

set -eu

if [ ! -f ".scripts/sh/setup/init.sh" ]; then
  echo "Run this script from the project root." >&2
  exit 1
fi

include_tracked=yes
case "${1:-}" in
  "") ;;
  --untracked-only) include_tracked=no ;;
  *) echo "Usage: $0 [--untracked-only]" >&2; exit 2 ;;
esac

printf '%s\n' "This will remove recognized initialization files, src/, tests/, requirements.txt, generated logs, and the repository pre-commit hook." "Project source and tests will be deleted; README.md, LICENSE, and .pre-commit-config.yaml will be restored from origin/main."
if [ "$include_tracked" = no ]; then
  echo "Untracked-only mode: tracked files will be preserved."
fi
printf '%s' "Continue? [y/N] "
read -r answer
case "$answer" in
  y|Y|yes|YES) ;;
  *) echo "Teardown cancelled."; exit 0 ;;
esac

readme_temp="$(mktemp)"
license_temp="$(mktemp)"
pre_commit_config_temp="$(mktemp)"
trap 'rm -f "$readme_temp" "$license_temp" "$pre_commit_config_temp"' EXIT HUP INT TERM
sh .scripts/sh/teardown/fetch-template-file.sh README.md "$readme_temp"
sh .scripts/sh/teardown/fetch-template-file.sh LICENSE "$license_temp"
sh .scripts/sh/teardown/fetch-template-file.sh .pre-commit-config.yaml "$pre_commit_config_temp"

sh .scripts/sh/teardown/hooks.sh
sh .scripts/sh/teardown/project-files.sh "$include_tracked"
sh .scripts/sh/teardown/logs.sh

if [ "$include_tracked" = yes ] || [ ! -e README.md ] ||
  ! git ls-files --error-unmatch README.md >/dev/null 2>&1; then
  mv "$readme_temp" README.md
  echo "Restored README.md from the upstream main branch."
fi

if [ "$include_tracked" = yes ] || [ ! -e LICENSE ] ||
  ! git ls-files --error-unmatch LICENSE >/dev/null 2>&1; then
  mv "$license_temp" LICENSE
  echo "Restored LICENSE from the upstream main branch."
fi

if [ "$include_tracked" = yes ] || [ ! -e .pre-commit-config.yaml ] ||
  ! git ls-files --error-unmatch .pre-commit-config.yaml >/dev/null 2>&1; then
  mv "$pre_commit_config_temp" .pre-commit-config.yaml
  echo "Restored .pre-commit-config.yaml from the upstream main branch."
fi

echo "Teardown completed. Review remaining project files and any pre-commit configuration edits manually."
