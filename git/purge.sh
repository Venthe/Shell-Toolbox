#!/usr/bin/env bash

# -r recurse
git rm -r --force .
# -d recurse into directories. -x Don’t use the standard ignore rules
git clean -xd --force