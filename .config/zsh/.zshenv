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

# Homebrew
export HOMEBREW_NO_INSTALL_CLEANUP=TRUE
export HOMEBREW_NO_ENV_HINTS=TRUE

# Puppeteer
# export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# fnm (loaded via dominik-schwabe/zsh-fnm in .zsh_plugins.txt)
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"

# pnpm
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

# bun
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

# Railway CLI (replaces the installer's `source ~/.railway/env` in .zshrc)
export RAILWAY_HOME="${RAILWAY_HOME:-$HOME/.railway}"

# Claude Code
export CLAUDE_CODE_NO_FLICKER=1

# Starship: point at the tracked config in this repo.
export STARSHIP_CONFIG="${DOTFILES_DIR}/.config/starship.toml"

# Dedupe paths
typeset -gU path fpath

# Add paths. Completions, evals, and interactive-only integrations live in .zshrc.d/.
# Vite+ bin goes first, matching where ~/.config/vite-plus/env puts it; its vp
# wrapper and completions are sourced from .zshrc.d/vite-plus.zsh.
path=(
	$XDG_DATA_HOME/vite-plus/bin(N)
	$HOME/{,s}bin(N)
	$HOME/.local/{,s}bin(N)
	/opt/{homebrew,local}/{,s}bin(N)
	/usr/local/{,s}bin(N)
	$PNPM_HOME/bin(N)
	$PNPM_HOME(N)
	$BUN_INSTALL/bin(N)
	$RAILWAY_HOME/bin(N)
	$HOME/.cargo/bin(N)
	$HOME/.posthog(N)
	$HOME/.orbstack/bin(N)
	$path
)

# Host-specific overrides and secrets (gitignored). Looked up next to this
# file's real location rather than in $ZDOTDIR, which is $HOME while
# Cursor/VS Code shell integration sources ~/.zshenv.
_zshenv_local=${${(%):-%x}:A:h}/.zshenv.local
[[ ! -f $_zshenv_local ]] || source $_zshenv_local
unset _zshenv_local
