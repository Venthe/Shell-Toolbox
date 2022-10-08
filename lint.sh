#!/usr/bin/env bash

find . -type f | grep '\.sh' | xargs -n1 shellcheck -f gcc
