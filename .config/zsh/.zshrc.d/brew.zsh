(( $+commands[brew] )) || return 0

# Cache `brew shellenv` output to avoid a ~20ms fork on every shell.
# Cache is refreshed when the brew binary itself is newer than the cache.
_brew_shellenv_cache=${XDG_CACHE_HOME:-$HOME/.cache}/brew-shellenv.zsh
if [[ ! -f $_brew_shellenv_cache || $commands[brew] -nt $_brew_shellenv_cache ]]; then
  mkdir -p ${_brew_shellenv_cache:h}
  brew shellenv > $_brew_shellenv_cache
fi
source $_brew_shellenv_cache
unset _brew_shellenv_cache
