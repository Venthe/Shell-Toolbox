#!/usr/bin/env bash

set -o errexit

function sanitize_directory_name() {
    sed 's/^\///g ; s/[\/:]/_/g ; s/[\.]/-/g'
}

echo -e "\n***** Downloading ${1}"
SANITIZED_IMAGE_NAME=$(printf ${1} | sanitize_directory_name)
docker pull --quiet "${1}" || true 
docker save "${1}" | gzip > "${SANITIZED_IMAGE_NAME}.tar.gz"