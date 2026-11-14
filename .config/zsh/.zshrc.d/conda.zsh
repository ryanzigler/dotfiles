#!/bin/zsh
#
# conda: defines the `conda` shell function and puts condabin on PATH.
# Replaces the `conda init` block in .zshrc. If `conda init` is run again it
# re-adds that block to .zshrc; delete it there and keep this file.
#

_conda_base=/opt/homebrew/Caskroom/miniconda/base

[[ -x $_conda_base/bin/conda ]] || {
	unset _conda_base
	return 0
}

if [[ -f $_conda_base/etc/profile.d/conda.sh ]]; then
	source $_conda_base/etc/profile.d/conda.sh
else
	eval "$($_conda_base/bin/conda shell.zsh hook 2>/dev/null)"
fi

unset _conda_base
