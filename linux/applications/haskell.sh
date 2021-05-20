#!/usr/bin/env bash

set -o xtrace

curl -sSL https://get.haskellstack.org/ | sh
git clone https://github.com/haskell/haskell-ide-engine
cd haskell-ide-engine
stack install
code --install-extension haskell.haskell