#!/usr/bin/env bash

ANSIBLE_STDOUT_CALLBACK=yaml ansible-playbook \
    --inventory inventory.yml \
    --ask-become \
    "${@}" \
    setup_local_environment.ansible.yml