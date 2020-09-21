#!/usr/bin/bash

set -o xtrace

apt update

local _GENERATE_SSH_KEYS=false
local _GIT=true
local _GIT_EMAIL="jacek.lipiec.bc@gmail.com"
local _VIM=true
local _DOS2UNIX=true
local _MAVEN=true
local _KUBECTL=false
local _HELM=false
local _VSCODE=true
local _SSH_SERVER=true
local _USE_SNAP_WHEN_POSSIBLE=false
local _INTELLIJ_IDEA=true
local _SET_ENGLISH_LOCALE=true
local _DOCKER=true
local _COPY_CONFIG=true

if [ _COPY_CONFIG ]; then
  cp ./config/* ~
fi

if [ _GENERATE_SSH_KEYS ]; then
  sudo ssh-keygen -b 2048 \
             -t rsa \
             -C ${_GIT_EMAIL} \
             -f ~/.ssh/id_rsa
             -q \
             -N ""
fi

if [ _GIT ]; then
  sudo apt install --assume-yes git
  git config --global user.name "Jacek Lipiec"
  git config --global user.email ${_GIT_EMAIL}
  git config --global core.editor vim
  git config --global core.pager less
  git config --global help.autocorrect 5
  git config --global color.ui true
  git config --global core.autocrlf true
  git config --global diff.renameLimit 65553
  git config --global diff.renames true
  git config --global diff.algorithm histogram
  git config --global feature.manyFiles true
  git config --global init.defaultBranch main
fi

if [ _VIM ]; then
  sudo apt install --assume-yes vim
fi

if [ _DOS2UNIX ]; then
  sudo apt install --assume-yes dos2unix
fi

if [ _MAVEN ]; then
  sudo apt install --assume-yes maven
fi

if [ _DOCKER ]; then
  sudo apt remove docker docker-engine docker.io containerd runc
  sudo apt install --assume-yes \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
     
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  sudo apt update
  sudo apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-compose

  sudo systemctl enable docker
  sudo groupadd docker
  sudo usermod -aG docker ${USER}
  sudo newgrp docker
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi

if [ _KUBECTL ]; then
  local _RELEASE_NAME="$(lsb_release -cs)"
  sudo apt install --assume-yes apt-transport-https gnupg2
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt update
  sudo apt install --assume-yes kubectl
fi

if [ _HELM ]; then
  sudo apt install --assume-yes apt-transport-https
  curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add -
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt update
  sudo apt install --assume-yes helm
fi

if [ _VSCODE ]; then
  if [ _USE_SNAP_WHEN_POSSIBLE ]; then
    snap install --classic code # or code-insiders
  else
    apt install --assume-yes apt-transport-https

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    
    sudo apt update
    sudo apt install --assume-yes code # or code-insiders
  fi
fi

if [ _SSH_SERVER ]; then
  sudo apt install --assume-yes openssh-server
  sudo systemctl enable ssh
fi

if [ _INTELLIJ_IDEA ]; then
  sudo snap install intellij-idea-ultimate --classic
fi

if [ _SET_ENGLISH_LOCALE ]; then
  sudo update-locale LANG=en_US.UTF-8 LANGUAGE
  sudo locale-gen "en_US.UTF-8"
  . /etc/default/locale
fi