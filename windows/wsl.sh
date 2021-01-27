#!/usr/bin/env bash

cat <<EOF > /tmp/resolv.conf
# This file was automatically generated by WSL. To stop automatic generation of this file, add the following entry to /etc/wsl.conf:
# [network]
# generateResolvConf = false
nameserver 8.8.8.8
EOF
sudo mv /tmp/resolv.conf /etc/resolv.conf

cat <<EOF > /tmp/wsl.conf
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=11"
[network]
generateResolvConf = false
EOF
sudo mv /tmp/wsl.conf /etc/wsl.conf

ln --symbolic --directory /mnt/c/Users/User/.ssh ~
