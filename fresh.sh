#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# `--macos` applies the macOS defaults in set in `.macos`
run_macos=false

for arg in "$@"; do
	case "$arg" in
	--macos) run_macos=true ;;
	*)
		echo "Usage: ./fresh.sh [--macos]" >&2
		exit 1
		;;
	esac
done

echo "Setting up your Mac..."

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
	echo "Xcode Command Line Tools not found. Installing..."
	xcode-select --install
else
	echo "Xcode Command Line Tools already installed."
fi

# Check for Homebrew and install if we don't have it
if ! command -v brew >/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# New shells get brew from .zshenv and .zshrc.d/brew.zsh for the rest of the script
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
link_safe "$PWD/.gitignore_global" "$HOME/.gitignore_global"

gitconfig_include='~/dotfiles/user.config/.gitconfig'

if [ -L "$HOME/.gitconfig" ]; then
	rm "$HOME/.gitconfig"
fi

if ! git config --file "$HOME/.gitconfig" --get-all include.path 2>/dev/null | grep -qxF "$gitconfig_include"; then
	git config --file "$HOME/.gitconfig" --add include.path "$gitconfig_include"
fi

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create sites subdirectories
mkdir -p "$HOME/Developer/work/crometrics"
mkdir -p "$HOME/Developer/personal"

# Clone Github repositories
./clone.sh

# Set macOS preferences last because it restarts Finder, Dock and other apps
if $run_macos; then
	source ./.macos
else
	echo "Skipped macOS defaults. Run ./fresh.sh --macos (or: source ./.macos) to apply them."
fi
