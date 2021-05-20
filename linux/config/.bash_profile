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
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_HIDE_IF_PWD_IGNORED=1
GIT_PS1_SHOWUPSTREAM="verbose name"

GIT_PS1='[$(__git_ps1 " (%s)")]\$ '
PS1="${PS1} ${GIT_PS1}"
export PS1

# Load binaries from /usr/local/bin first (e.g. homebrew packages)
export PATH=/usr/local/bin:$PATH

# Load binares from Python's ~/.local/bin
export PATH=$HOME/.local/bin:$PATH

# set PATH so it includes my private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
