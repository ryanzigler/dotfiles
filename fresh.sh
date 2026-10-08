#!/usr/bin/env bash

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

	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Initialize submodules (antidote, etc.)
git submodule update --init --recursive

CONFIG_SOURCE_DIR="$PWD/.config"
CONFIG_TARGET_DIR="$HOME/.config"

if [ -d "$CONFIG_SOURCE_DIR" ]; then
	mkdir -p "$CONFIG_TARGET_DIR"

	for dir in "$CONFIG_SOURCE_DIR"/*; do
		[ -d "$dir" ] || continue

		name=$(basename "$dir")
		target="$CONFIG_TARGET_DIR/$name"

		if [ -e "$target" ] && [ ! -L "$target" ]; then
			echo "Refusing to clobber existing non-symlink: $target" >&2
			continue
		fi

		rm -rf "$target"
		ln -s "$dir" "$target"
	done
fi

link_safe() {
	src="$1"
	dst="$2"

	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		echo "Refusing to clobber existing non-symlink: $dst" >&2
		return 1
	fi

	rm -f "$dst"
	ln -s "$src" "$dst"
}

link_safe "$CONFIG_TARGET_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_safe "$CONFIG_TARGET_DIR/zsh/.zshenv" "$HOME/.zshenv"
link_safe "$PWD/user.config/.gitconfig" "$HOME/.gitconfig"
link_safe "$PWD/.gitignore_global" "$HOME/.gitignore_global"

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create sites subdirectories
mkdir -p "$HOME/Developer/work/crometrics"
mkdir -p "$HOME/Developer/personal"

# Clone Github repositories
./clone.sh

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos
