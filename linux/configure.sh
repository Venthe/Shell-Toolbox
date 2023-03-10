#!/usr/bin/env bash

set -o xtrace

apt update

_GENERATE_SSH_KEYS=false
_GIT=true
_GIT_EMAIL="jacek.lipiec.bc@gmail.com"
_VIM=true
_DOS2UNIX=true
_MAVEN=true
_VSCODE=true
_SSH_SERVER=true
_USE_SNAP_WHEN_POSSIBLE=false
_INTELLIJ_IDEA=true
_SET_ENGLISH_LOCALE=true
_DOCKER=true
_COPY_CONFIG=true

if [ $_COPY_CONFIG ]; then
  cp ./config/* ~
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.sh
fi

if [ $_MAVEN ]; then
  sudo apt install --assume-yes maven
fi

if [ $_DOCKER ]; then
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
  sudo usermod -aG docker "${USER}"
  sudo newgrp docker
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi

if [ $_HELM ]; then
  sudo apt install --assume-yes apt-transport-https
  curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add -
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt update
  sudo apt install --assume-yes helm
fi

if [ $_VSCODE ]; then
  if [ $_USE_SNAP_WHEN_POSSIBLE ]; then
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

if [ $_SSH_SERVER ]; then
  sudo apt install --assume-yes openssh-server
  sudo systemctl enable ssh
fi

if [ $_INTELLIJ_IDEA ]; then
  sudo snap install intellij-idea-ultimate --classic
fi

if [ $_SET_ENGLISH_LOCALE ]; then
  sudo update-locale LANG=en_US.UTF-8 LANGUAGE
  sudo locale-gen "en_US.UTF-8"
  # shellcheck disable=SC1091
  . /etc/default/locale
fi