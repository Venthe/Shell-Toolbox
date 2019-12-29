#!/bin/bash -xe

git clone $1 $2
cd $2
git checkout `git rev-parse HEAD`
git fetch origin +refs/heads/*:refs/heads/*
git checkout master
cd -