#!/usr/bin/env bash

docker run --rm --volume "${PWD}:/mnt" koalaman/shellcheck:stable "${@}"