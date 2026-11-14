#!/bin/zsh
#
# Vite+ (https://viteplus.dev): `vp` wrapper and completions.
#
# Needs compdef, so it runs here after antidote rather than in .zshenv.
# Kept in `vp env off` mode so Node comes from fnm.

[[ -f $XDG_CONFIG_HOME/vite-plus/env ]] && source $XDG_CONFIG_HOME/vite-plus/env
