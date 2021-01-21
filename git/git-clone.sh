#!/usr/bin/env bash

# Exit immediately if a pipeline returns a non-zero status
set -e

if [[ ${#} -ne 2 ]] && [[ ${#} -ne 1 ]]; then
  echo "There should be exactly 1 or 2 arguments, but there was ${#}"
  exit 1
fi

PROJECT_URI="${1}"
if [[ ${#} -eq 2 ]]; then
    CLONE_DIRECTORY="${2}"
else
    CLONE_DIRECTORY=$(basename "${PROJECT_URI}" .git)
fi

# Print a trace of simple commands
# set -x
git clone \
    --progress \
    --verbose \
    "${PROJECT_URI}" "${CLONE_DIRECTORY}"

cd "${CLONE_DIRECTORY}"

# Fetch all refs from all remotes
git fetch --progress --all --tags

# Creates and tracks branches from all remotes
# shellcheck disable=SC2016
#  Expansion should happen inside spawned bash instance
git show-ref \
    | grep refs/remotes \
    | awk '{print $2}' \
    | xargs --max-args=1 -I @ \
    bash --restricted -c 'git switch --progress --force --force-create $(git rev-parse --abbrev-ref @) @'

git gc --aggressive
