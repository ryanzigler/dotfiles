#!/bin/zsh
#
# .zshenv - Zsh environment file, loaded always.
#

# NOTE: .zshenv needs to live at ~/.zshenv, not in $ZDOTDIR!

# Set ZDOTDIR if you want to re-home Zsh.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Text Editor
export EDITOR="nano"
export VISUAL="$EDITOR"

# fnm
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"

# Homebrew
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
export HOMEBREW_NO_ENV_HINTS=TRUE

# Puppeteer
# export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

# bun
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

# pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

# Claude Code
export CLAUDE_CODE_NO_FLICKER=1

# Starship: point at the tracked config in this repo.
export STARSHIP_CONFIG="${DOTFILES_DIR}/.config/starship.toml"

# Dedupe paths
typeset -gU path fpath

# Add paths. Completions, evals, and interactive-only integrations live in .zshrc.d/.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $PNPM_HOME(N)
  $BUN_INSTALL(N)/bin(N)
  $PYENV_ROOT(N)/bin(N)
  $HOME/.cargo/bin(N)
  $HOME/.posthog(N)
  $HOME/.orbstack/bin(N)
  $path
)

# Host-specific overrides and secrets (gitignored)
[[ -f ${ZDOTDIR}/.zshenv.local ]] && source ${ZDOTDIR}/.zshenv.local
