#!/bin/bash

set -e

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # Mac
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew installing....."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Make brew available in this script process right after installation.
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  brew install fzf eza bat ripgrep starship tmux chezmoi
elif [ "$OS" = "Linux" ]; then
  # Linux / WSL
  sudo apt update
  sudo apt install -y fzf eza bat ripgrep tmux
  curl -sS https://starship.rs/install.sh | sh -s -- --yes

  if ! command -v chezmoi >/dev/null 2>&1; then
    mkdir -p "$HOME/bin"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/bin"
    export PATH="$HOME/bin:$PATH"
  fi
fi

# dotfilesを適用
chezmoi init --apply https://github.com/TaroHubee/dotfiles.git

# vim-plug プラグインインストール
if command -v vim >/dev/null 2>&1; then
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  vim +PlugInstall +qall
fi

echo "Complete Set Up !!!"
