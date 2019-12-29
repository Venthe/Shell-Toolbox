#!/bin/bash -xe

repository=$1
directory=$2

git clone $repository $directory
cd $directory
git checkout `git rev-parse HEAD`
git fetch origin +refs/heads/*:refs/heads/*
git checkout master
cd -