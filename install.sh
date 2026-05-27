#!/bin/bash

set -e

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # Mac
  if ! command -v brew &>/dev/null; then
    echo "Homebrew installing....."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install fzf eza bat ripgrep starship
elif [ "$OS" = "Linux" ]; then
  # Linux / WSL
  sudo apt update
  sudo apt install -y fzf eza bat ripgrep
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

if ! command -v chezmoi &>/dev/null; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/bin"
fi

export PATH="$HOME/bin:$PATH"

# dotfilesを適用
chezmoi init --apply git@github.com:TaroHubee/dotfiles.git

# vim-plug プラグインインストール
vim +PlugInstall +qall

echo "Complete Set Up !!!"





