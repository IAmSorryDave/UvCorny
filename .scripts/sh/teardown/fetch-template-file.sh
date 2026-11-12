#!/bin/sh

set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 FILE_NAME OUTPUT_FILE" >&2
  exit 2
fi

template_file=$1
output_file=$2
case "$template_file" in
  README.md|LICENSE|.pre-commit-config.yaml) ;;
  *) echo "Unsupported template file: $template_file" >&2; exit 2 ;;
esac

if ! remote_url=$(git remote get-url origin 2>/dev/null); then
  echo "Could not determine the GitHub repository from the origin remote; teardown was not started." >&2
  exit 1
fi

case "$remote_url" in
  https://github.com/*|http://github.com/*)
    remote_repo=${remote_url#*github.com/}
    ;;
  git@github.com:*)
    remote_repo=${remote_url#git@github.com:}
    ;;
  ssh://git@github.com/*)
    remote_repo=${remote_url#ssh://git@github.com/}
    ;;
  *)
    echo "The origin remote must point to a GitHub repository; teardown was not started." >&2
    exit 1
    ;;
esac

remote_repo=${remote_repo%/}
remote_repo=${remote_repo%.git}
remote_owner=${remote_repo%%/*}
remote_name=${remote_repo#*/}
if [ -z "$remote_owner" ] || [ -z "$remote_name" ] || [ "$remote_name" = "$remote_repo" ] ||
   [ "${remote_name#*/}" != "$remote_name" ]; then
  echo "The origin remote is not a valid GitHub owner/repository URL; teardown was not started." >&2
  exit 1
fi

file_url="https://raw.githubusercontent.com/$remote_owner/$remote_name/main/$template_file"
if ! wget -qO "$output_file" "$file_url" || [ ! -s "$output_file" ]; then
  echo "Could not fetch the template $template_file; teardown was not started." >&2
  exit 1
fi