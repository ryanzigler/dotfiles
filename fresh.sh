#!/bin/sh

echo "Setting up your Mac..."

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

CONFIG_SOURCE_DIR="$PWD/.config"
CONFIG_TARGET_DIR="$HOME/.config"

if [ -d "$CONFIG_SOURCE_DIR" ]; then
  mkdir -p "$CONFIG_TARGET_DIR"

  for dir in "$CONFIG_SOURCE_DIR"/*; do
    [ -d "$dir" ] || continue

    name=$(basename "$dir")
    target="$CONFIG_TARGET_DIR/$name"

    rm -rf "$target"
    ln -s "$dir" "$target"
  done
fi

rm -f "$HOME/.zshrc"
ln -s "$CONFIG_TARGET_DIR/zsh/.zshrc" "$HOME/.zshrc"

rm -f "$HOME/.zshenv"
ln -s "$CONFIG_TARGET_DIR/zsh/.zshenv" "$HOME/.zshenv"


# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create sites subdirectories
mkdir $HOME/Code
mkdir $HOME/Code/work
mkdir $HOME/Code/crometrics

# Clone Github repositories
./clone.sh

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos
