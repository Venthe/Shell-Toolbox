#!/usr/bin/env bash

function docker_run() {
    docker run --rm \
        --interactive \
        "${@}"
}

function xq() {
    docker_run \
        --workdir="/workdir" \
        --volume="${PWD}:/workdir" \
        alpine/xml xq .
}

function checkstyle() {
    function _checkstyle() {
        docker_run \
            --volume="${PWD}:/checkstyle/workdir" \
            venthe/checkstyle \
            -f xml \
            -c /checkstyle/rules/google_checks.xml \
            "${@}" \
            | xq
    }

    # function last_commit() {
    #     FILES=$(_git files_to_verify | xargs)
    #     _checkstyle "$FILES" "${@}"
    # }

    # function all() {
    #     _checkstyle ./ "${@}"
    # }

    _checkstyle "${@}"
}

function build() {
    echo "1"
    docker build ./docker/checkstyle
}

"${@}"
