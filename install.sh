#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
#if test ! $(which omz); then
#  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
#fi

# Check for Homebrew and install if we don't have it
#if test ! $(which brew); then
#  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#fi

# Update Homebrew recipes
#brew update

# Install all our dependencies with bundle (See Brewfile)
#brew tap homebrew/bundle
#brew bundle --file ~/.dotfiles/Brewfile

# Create a Sites directory
#mkdir $HOME/Coding

# Create sites subdirectories
mkdir $HOME/Coding/crometrics

# Clone Github repositories
./clone.sh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences - we will run this last because this will reload the shell
source ~$HOME/.dotfiles/.macos
