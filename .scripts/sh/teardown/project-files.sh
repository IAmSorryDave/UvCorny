#!/bin/sh

set -eu

include_tracked=${1:-no}

remove_project_file() {
  file=$1
  if [ -f "$file" ] && {
    [ "$include_tracked" = yes ] || ! git ls-files --error-unmatch "$file" >/dev/null 2>&1
  }; then
    rm -f -- "$file"
    printf 'Removed %s\n' "$file"
  fi
}

for file in pyproject.toml uv.lock .python-version LICENSE .gitignore README.md main.py hello.py requirements.txt; do
  remove_project_file "$file"
done

if [ -d tests ] && {
  [ "$include_tracked" = yes ] || ! git ls-files --error-unmatch tests >/dev/null 2>&1
}; then
  rm -rf -- tests
  printf '%s\n' "Removed tests/"
fi

if [ -d src ] && {
  [ "$include_tracked" = yes ] || ! git ls-files --error-unmatch src >/dev/null 2>&1
}; then
  rm -rf -- src
  printf '%s\n' "Removed src/"
fi

