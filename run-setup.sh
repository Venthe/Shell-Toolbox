#!/usr/bin/env bash

sudo apt-get install --assume-yes \
    software-properties-common
sudo add-apt-repository --assume-yes \
    ppa:deadsnakes/ppa
sudo apt-get update --assume-yes
sudo apt-get install --assume-yes \
    "python3.10" python3-pip

python3 -m pip install --user ansible

IS_PATH_SET=`cat ${HOME}/.bashrc | grep -E "PATH=${HOME}/\.local/bin" > /dev/null; printf "${?}"`
if [[ IS_PATH_SET -eq "1" ]]; then
    echo PATH="\${HOME}/.local/bin:\${PATH}" >> ${HOME}/.bashrc && . ${HOME}/.bashrc
fi

ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook \
    --inventory inventory.yml \
    --ask-become \
    "${@}" \
    setup_local_environment.ansible.yml