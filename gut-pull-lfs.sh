#!/bin/bash -xe

for dir in ./*/
do
  cd ${dir}
  git lfs pull
  cd ..
done