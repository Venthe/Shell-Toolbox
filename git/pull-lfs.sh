#!/usr/bin/env bash

set -x
set -e

for dir in ./*/ ; do
  cd "${dir}"
  git lfs pull
  cd ..
done
