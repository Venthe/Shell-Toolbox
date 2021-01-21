#!/usr/bin/env bash

find . -type f | grep '\.sh' | xargs -n1 ./bash/shellcheck.sh
