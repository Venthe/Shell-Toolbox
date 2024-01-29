#!/usr/bin/env bash

set -o pipefail
set -o errexit

INVENTORY=./inventory.yml

# sudo apt-get install --assume-yes \
#     software-properties-common
# sudo add-apt-repository -y \
#     ppa:deadsnakes/ppa
# sudo apt-get update --assume-yes
# sudo apt-get install --assume-yes \
#     python3 python3-pip

# python3 -m pip install --upgrade --user ansible pyopenssl

# IS_PATH_SET=`cat ${HOME}/.bashrc | grep -E '^PATH=\${HOME}/\.local/bin' > /dev/null; printf "${?}"`
# if [[ IS_PATH_SET -eq "1" ]]; then
#     echo PATH="\${HOME}/.local/bin:\${PATH}" >> ${HOME}/.bashrc && . ${HOME}/.bashrc
# fi

# if [[ ! -f "${INVENTORY}" ]]; then
#     echo "
# ungrouped:
#   hosts:
#     localhost:
#      ansible_connection: local
#   vars:
#     git:
#       username: "Jacek Lipiec"
#       email: "jacek.lipiec.bc@gmail.com"
# " >> "${INVENTORY}"
# fi

export PATH="${PATH};/home/venthe/.local/bin"

ansible-galaxy collection install community.crypto community.general

ANSIBLE_STDOUT_CALLBACK=yaml ANSIBLE_CALLBACKS_ENABLED="timer" ansible-playbook \
    --inventory "${INVENTORY}" \
    --ask-become \
    "${@}" \
    setup_local_environment.ansible.yml