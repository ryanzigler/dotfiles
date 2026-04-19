#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# Zsh options.
setopt extended_glob
setopt auto_cd

# Ghostty shell integration
if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# Lazy-load (autoload) Zsh function files from a directory.
ZFUNCDIR=${ZDOTDIR:-$HOME}/.zfunctions
fpath=($ZFUNCDIR $fpath)
autoload -Uz $ZFUNCDIR/*(.:t)

# Set any zstyles you might use for configuration.
[[ ! -f ${ZDOTDIR:-$HOME}/.zstyles ]] || source ${ZDOTDIR:-$HOME}/.zstyles

# Antidote: lazy-load pattern. Only source antidote.zsh when the static file
# needs regenerating; otherwise just source the cached static file directly.
# See: https://github.com/mattmc3/antidote#static-mode
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins

if [[ ! -d ${ZDOTDIR:-$HOME}/.antidote ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote ${ZDOTDIR:-$HOME}/.antidote
fi

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh && antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh)
fi

source ${zsh_plugins}.zsh

# Lazy-load antidote itself so `antidote update`, `antidote list`, etc. still work.
antidote() {
  unset -f antidote
  source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
  antidote "$@"
}

unset zsh_plugins

# Source anything in .zshrc.d.
for _rc in ${ZDOTDIR:-$HOME}/.zshrc.d/*.zsh; do
  # Ignore tilde files.
  if [[ $_rc:t != '~'* ]]; then
    source "$_rc"
  fi
done
unset _rc

# bun: BUN_INSTALL, PATH, and completions are set in .zshenv.
# gcloud PATH + completion are sourced from .zshrc.d/gcloud.zsh (completion is deferred).

ulimit -n 65536
