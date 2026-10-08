# Interactive-only completion wiring. Runs after antidote load but before
# ez-compinit's deferred compinit fires, so fpath additions here are picked up.

# OrbStack completions
[[ -d /Applications/OrbStack.app/Contents/Resources/completions/zsh ]] &&
	fpath+=(/Applications/OrbStack.app/Contents/Resources/completions/zsh)

# bun completions (#compdef bun)
[[ -s $HOME/.bun/_bun ]] && source $HOME/.bun/_bun
