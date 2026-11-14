#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#
# bun, pnpm, Railway, and Vite+: env vars and PATH are set in .zshenv.
# Completions (bun, OrbStack, vastai) are wired in .zshrc.d/completions.zsh.
# Vite+'s vp wrapper and completions come from .zshrc.d/vite-plus.zsh.
# conda is initialised from .zshrc.d/conda.zsh.
# gcloud PATH + completion are sourced from .zshrc.d/gcloud.zsh (completion is deferred).
# History size and options are set in .zshrc.d/history.zsh, after the history plugin.
#

# Resolve this file's real directory so Cursor/VS Code shell integration (which sources ~/.zshrc with ZDOTDIR=$HOME) still finds the config.
ZSH_CONFIG_DIR=${${(%):-%x}:A:h}

# Zsh options.
setopt extended_glob
setopt auto_cd

# Ghostty shell integration
if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
	builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Lazy-load (autoload) Zsh function files from a directory.
ZFUNCDIR=$ZSH_CONFIG_DIR/.zfunctions
fpath=($ZFUNCDIR $fpath)

autoload -Uz $ZFUNCDIR/*(.N:t)

# Set any zstyles you might use for configuration.
[[ ! -f $ZSH_CONFIG_DIR/.zstyles ]] || source $ZSH_CONFIG_DIR/.zstyles

# Antidote: lazy-load pattern. Only source antidote.zsh when the static file
# needs regenerating; otherwise just source the cached static file directly.
# See: https://github.com/mattmc3/antidote#static-mode
zsh_plugins=$ZSH_CONFIG_DIR/.zsh_plugins

# .antidote is a git submodule. A clone made without --recursive leaves an empty
# directory behind, so test for the script rather than the directory.
if [[ ! -f $ZSH_CONFIG_DIR/.antidote/antidote.zsh ]]; then
	git -C $ZSH_CONFIG_DIR submodule update --init .antidote
fi

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
	(source $ZSH_CONFIG_DIR/.antidote/antidote.zsh && antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh)
fi

source ${zsh_plugins}.zsh

# Lazy-load antidote itself so `antidote update`, `antidote list`, etc. still work.
antidote() {
	unset -f antidote
	source $ZSH_CONFIG_DIR/.antidote/antidote.zsh
	antidote "$@"
}

unset zsh_plugins

# Source anything in .zshrc.d.
for _rc in $ZSH_CONFIG_DIR/.zshrc.d/*.zsh; do
	# Ignore tilde files.
	if [[ $_rc:t != '~'* ]]; then
		source "$_rc"
	fi
done

unset _rc

ulimit -n 65536

# Put ~/.local/bin first and drop duplicates added by installers' `export PATH=` lines.
path=($HOME/.local/bin $path)
