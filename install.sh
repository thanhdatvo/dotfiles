#!/bin/bash

# install node
brew install nvm
source ~/.zshrc
nvm install --lts # Install latest stable Node
nvm use --lts     # Switch to it

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install python
brew install uv
uv python install 3.12
uv python pin 3.12

#install go
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm install go1.26.2 -B
gvm use go1.26.2 --default

#install nix??
# sh <(curl -L https://nixos.org/nix/install) --daemon

# other utility tool
brew install zoxide
brew install pyenv
brew install lazygit
brew install gitmux
brew install fzf
brew install bat # better cat
brew install lsd # better ls
