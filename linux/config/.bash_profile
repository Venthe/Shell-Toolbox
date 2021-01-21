LANG="en_US.utf8"
export LANG

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

. ~/.git-completion.sh
. ~/.git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"

PS1=$PS1'$(__git_ps1 " (%s)")'
export PS1

# Load binaries from /usr/local/bin first (e.g. homebrew packages)
export PATH=/usr/local/bin:$PATH

# set PATH so it includes my private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
