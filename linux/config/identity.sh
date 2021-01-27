#!/usr/bin/env bash

mkdir –p ~/.ssh
chmod 0600 ~/.ssh
ssh-keygen -t rsa -C "example@gmail.com"
#ssh-copy-id username@<server_IP>
