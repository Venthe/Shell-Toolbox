#!/usr/bin/env bash

set -o xtrace

apt update

_GENERATE_SSH_KEYS=false
_GIT=true
_GIT_EMAIL="jacek.lipiec.bc@gmail.com"
_VIM=true
_DOS2UNIX=true
_MAVEN=true
_KUBECTL=false
_HELM=false
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

if [ $_GENERATE_SSH_KEYS ]; then
  sudo ssh-keygen -b 2048 \
             -t rsa \
             -C ${_GIT_EMAIL} \
             -f ~/.ssh/id_rsa \
             -q \
             -N ""
fi

if [ $_GIT ]; then
  sudo apt install --assume-yes git
  git config --global user.name "Jacek Lipiec"
  git config --global user.email ${_GIT_EMAIL}
  git config --global color.ui true
  git config --global core.autocrlf true
  git config --global core.editor vim
  git config --global core.pager less
  git config --global diff.algorithm histogram
  git config --global diff.renameLimit 65553
  git config --global diff.renames true
  git config --global feature.manyFiles true
  git config --global help.autocorrect 5
  git config --global init.defaultBranch main
  git config --global merge.conflictstyle diff3
  git config --global rebase.autosquash true
  git config --global alias.rebase-fixup git 'rebase --interactive --autosquash --no-edit'
  git config --global alias.lol 'll -1 --stat'
  git config --global alias.last 'log -1 --stat'
  git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Creset %s %Cblue[%cn|%ad|%D]%Creset" --date="format:%Y-%m-%d" --decorate'
  git config --global alias.raw-json-log "log --pretty=format:'{__SEPARATOR__commit__SEPARATOR__: __SEPARATOR__%H__SEPARATOR__,__SEPARATOR__abbreviated_commit__SEPARATOR__: __SEPARATOR__%h__SEPARATOR__,__SEPARATOR__tree__SEPARATOR__: __SEPARATOR__%T__SEPARATOR__,__SEPARATOR__abbreviated_tree__SEPARATOR__: __SEPARATOR__%t__SEPARATOR__,__SEPARATOR__parent__SEPARATOR__: __SEPARATOR__%P__SEPARATOR__,__SEPARATOR__abbreviated_parent__SEPARATOR__: __SEPARATOR__%p__SEPARATOR__,__SEPARATOR__refs__SEPARATOR__: __SEPARATOR__%D__SEPARATOR__,__SEPARATOR__encoding__SEPARATOR__: __SEPARATOR__%e__SEPARATOR__,__SEPARATOR__subject__SEPARATOR__: __SEPARATOR__%s__SEPARATOR__,__SEPARATOR__sanitized_subject_line__SEPARATOR__: __SEPARATOR__%f__SEPARATOR__,__SEPARATOR__body__SEPARATOR__: __SEPARATOR__%b__SEPARATOR__,__SEPARATOR__commit_notes__SEPARATOR__: __SEPARATOR__%N__SEPARATOR__,__SEPARATOR__verification_flag__SEPARATOR__: __SEPARATOR__%G?__SEPARATOR__,__SEPARATOR__signer__SEPARATOR__: __SEPARATOR__%GS__SEPARATOR__,__SEPARATOR__signer_key__SEPARATOR__: __SEPARATOR__%GK__SEPARATOR__,__SEPARATOR__author__SEPARATOR__: {  __SEPARATOR__name__SEPARATOR__: __SEPARATOR__%aN__SEPARATOR__, __SEPARATOR__email__SEPARATOR__: __SEPARATOR__%aE__SEPARATOR__, __SEPARATOR__date__SEPARATOR__: __SEPARATOR__%aD__SEPARATOR__},__SEPARATOR__commiter__SEPARATOR__: { __SEPARATOR__name__SEPARATOR__: __SEPARATOR__%cN__SEPARATOR__, __SEPARATOR__email__SEPARATOR__: __SEPARATOR__%cE__SEPARATOR__, __SEPARATOR__date__SEPARATOR__: __SEPARATOR__%cD__SEPARATOR__}}'"
  git config --global alias.json-log '!_f() { git raw-json-log ${@} | sed ''s/\"/\\\"/g''| sed ''s/__SEPARATOR__/\"/g'' | jq --slurp --monochrome-output .; }; _f'
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.st 'status --short --branch'
  git config --global alias.sdiff 'difftool --tool="vimdiff" -y'
  git config --global alias.read-config 'config --global --list'
  git config --global alias.search '!git rev-list --all | xargs git grep --fixed-strings'
  git config --global alias.renormalize '!git add --renormalize . && git commit -m "Introduce end-of-line normalization"'
  git config --global alias.purge '!git rm -r --force . && git clean -xd --force'
  git config --global alias.b '!git for-each-ref --sort="-authordate" --format="%(authordate)%09%(objectname:short)%09%(refname)" refs/heads | sed -e "s-refs/heads/--"'
  git config --global alias.ammend-this '!git add --all && git commit --amend --no-edit'
  git config --global alias.ac '!git add -all && git commit --all --message'
fi

if [ $_VIM ]; then
  sudo apt install --assume-yes vim
fi

if [ $_DOS2UNIX ]; then
  sudo apt install --assume-yes dos2unix
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

if [ $_KUBECTL ]; then
  sudo apt install --assume-yes apt-transport-https gnupg2
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt update
  sudo apt install --assume-yes kubectl
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

# Lazygit
sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update
sudo apt-get install lazygit

# MC
sudo apt install mc

# K9S
curl --silent \
     --location \
     https://github.com/derailed/k9s/releases/download/v0.24.7/k9s_Linux_x86_64.tar.gz \
  | tar --verbose \
        --gzip \
        --extract \
        --overwrite \
        --directory=~/.local/bin \
        k9s
