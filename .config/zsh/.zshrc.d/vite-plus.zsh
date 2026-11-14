#!/bin/zsh
#
# Vite+ (https://viteplus.dev): the `vp` wrapper (so `vp env use` can change
# this shell) and vp/vpr completions. The installer's env file only wires
# completions when compdef exists, which is true here (after antidote) but not
# in .zshenv. Its bin dir is already on PATH from .zshenv.
#

[[ -f $XDG_CONFIG_HOME/vite-plus/env ]] && source $XDG_CONFIG_HOME/vite-plus/env
