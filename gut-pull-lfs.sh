#!/bin/bash -xe

for directory in ./*/
do
  cd ${directory}
  git lfs pull
  cd -
done