#!/usr/bin/env bash

ansible-playbook \
    --inventory inventory.yaml \
    --ask-become \
    "${@}" \
    setup_local_environment.ansible.yml