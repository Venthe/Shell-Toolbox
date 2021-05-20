#!/usr/bin/env bash

# set -x
# set -e

_WORKING_DIR="${1:-.}"

for current_directory in ${_WORKING_DIR}/*/ ; do
  cd "${current_directory}"
  _IS_WORKING_TREE=`git rev-parse --is-inside-work-tree`
  if [[ "${_IS_WORKING_TREE}" -eq "true" ]]; then
    _IS_DIRTY=`git diff-index --quiet HEAD`
    if [[ "${_IS_DIRTY}" -eq 1 ]]; then
      echo "${current_directory}"
    fi
  fi
  cd -
done
