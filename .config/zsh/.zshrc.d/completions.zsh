# Interactive-only completion wiring. Runs after antidote load but before
# ez-compinit's deferred compinit fires, so fpath additions here are picked up.

# OrbStack completions
[[ -d /Applications/OrbStack.app/Contents/Resources/completions/zsh ]] &&
	fpath+=(/Applications/OrbStack.app/Contents/Resources/completions/zsh)

# bun completions (#compdef bun). BUN_INSTALL is set in .zshenv.
[[ -s $BUN_INSTALL/_bun ]] && source $BUN_INSTALL/_bun

# vastai completions. Replaces the installer's `. ~/.local/share/vastai/env.sh`,
# whose only other job (adding ~/.local/bin to PATH) .zshenv already does.
[[ -f $XDG_DATA_HOME/vastai/share/vastai-completion.zsh ]] && source $XDG_DATA_HOME/vastai/share/vastai-completion.zsh
