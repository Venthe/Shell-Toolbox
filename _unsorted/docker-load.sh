#!/bin/env bash

set -o errexit

SANITIZED_IMAGE_NAME=$(printf ${1} | ./_utils.sh sanitize_directory_name)
gunzip "${SANITIZED_IMAGE_NAME}.tar.gz" && docker load --input "${SANITIZED_IMAGE_NAME}.tar"