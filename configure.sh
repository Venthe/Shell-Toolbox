#!/usr/bin/bash

set -o xtrace

# Root check
if [[ $EUID -ne 0 ]]; then echo "Run this as the root user"; exit 1; fi

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
local _BASHRC

if [ _BASHRC ]; then

fi

if [ _GENERATE_SSH_KEYS ]; then
  ssh-keygen -b 2048 \
             -t rsa \
             -C ${_GIT_EMAIL} \
             -f ~/.ssh/id_rsa
             -q \
             -N ""
fi

if [ _GIT ]; then
  apt install --assume-yes git
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

  cp ./config/.gitignore_global ~
  cp ./config/.git-prompt.sh ~
  cp ./config/.git-completion.sh ~
fi

if [ _VIM ]; then
  apt install --assume-yes vim
fi

if [ _DOS2UNIX ]; then
  apt install --assume-yes dos2unix
fi

if [ _MAVEN ]; then
  apt install --assume-yes maven
fi

if [ _DOCKER ]; then
  apt remove docker docker-engine docker.io containerd runc
  apt install --assume-yes \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
     
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  apt update
  apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-compose
      
  
  systemctl enable docker
  groupadd docker
  usermod -aG docker ${USER}
  newgrp docker
  chown "$USER":"$USER" /home/"$USER"/.docker -R
  chmod g+rwx "$HOME/.docker" -R
fi

if [ _KUBECTL ]; then
  local _RELEASE_NAME="$(lsb_release -cs)"
  apt install --assume-yes apt-transport-https gnupg2
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
  apt update
  apt install --assume-yes kubectl
fi

if [ _HELM ]; then
  apt install --assume-yes apt-transport-https
  curl https://helm.baltorepo.com/organization/signing.asc | apt-key add -
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
  apt update
  apt install --assume-yes helm
fi

if [ _VSCODE ]; then
  if [ _USE_SNAP_WHEN_POSSIBLE ]; then
    snap install --classic code # or code-insiders
  else
    apt install --assume-yes apt-transport-https

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main"  | tee /etc/apt/sources.list.d/vscode.list
    
    apt update
    apt install --assume-yes code # or code-insiders
  fi
fi

if [ _SSH_SERVER ]; then
  apt install --assume-yes openssh-server
  systemctl enable ssh
fi

if [ _INTELLIJ_IDEA ]; then
  snap install intellij-idea-ultimate --classic
fi

if [ _SET_ENGLISH_LOCALE ]; then
  update-locale LANG=en_US.UTF-8 LANGUAGE
  locale-gen "en_US.UTF-8"
  . /etc/default/locale
fi