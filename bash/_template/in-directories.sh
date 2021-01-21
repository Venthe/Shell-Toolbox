#!/usr/bin/env bash

for directory in ./*/
do
  cd "${directory}" || exit 1
  # Place command here
  cd - || exit 1
done