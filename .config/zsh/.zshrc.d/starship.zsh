(($+commands[starship])) || return 0

# Cache `starship init zsh` output so we don't fork starship on every shell.
# Refreshed when the starship binary is newer than the cache.
_starship_cache=${XDG_CACHE_HOME:-$HOME/.cache}/starship-init.zsh

if [[ ! -f $_starship_cache || $commands[starship] -nt $_starship_cache ]]; then
	mkdir -p ${_starship_cache:h}
	starship init zsh --print-full-init >$_starship_cache
fi

source $_starship_cache
unset _starship_cache
