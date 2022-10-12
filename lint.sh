#!/usr/bin/env bash

# Show commands
# set -o xtrace

# Early exit on error
set -o errexit

# Pass errors through pipes
set -o pipefail

# Executes a command found via pattern
# $1 - Command to be executed
#      Please use '{}' to substitute filename.
# $2 - Pattern
#      Patten accepts `file` -iname syntax
function apply_on_file() {
    local command="${1}"
    local pattern="${2}"
    local name="${3:lint}"
    >&2 echo -e "\n* ${name}"
    find . -type f -iname "${pattern}" -print0 \
      | xargs -0 -n1 -I{} bash -c "${command}"
}

apply_on_file 'shellcheck -f gcc {}' '*.sh' 'Shellcheck' || true
apply_on_file 'ansible-lint --parseable-severity --nocolor -p {}' '*.ansible.y*ml' 'Ansible lint' || true
