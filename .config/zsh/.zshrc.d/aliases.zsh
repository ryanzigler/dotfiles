#
# .aliases - Set whatever shell aliases you want.
#

# Color palettes:
# - `LS_COLORS`: Read by GNU `ls`, `tree`, `fd` and `gls`;
# - `LSCOLORS`: Read by BSD/macOS `ls`.
export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'

# Color only when writing to a terminal; keyed on $OSTYPE
if [[ $OSTYPE == darwin* ]]; then
	colorflag="-G"
else
	colorflag="--color=auto"
fi

# Long listing with human-readable sizes
alias ll='ls -lh'
# List all files, including hidden ones
alias la='ls -lAh ${colorflag}'
# List dotfiles
alias ldot='ls -ld ${colorflag} .*'
# List only directories
alias lsd="CLICOLOR_FORCE=1 ls -lF ${colorflag} | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls ${colorflag}"

alias grep='grep --color=auto'

# Fix common typos
alias cd..='cd ..'
alias get="git "
alias got="git "
alias quit='exit'

# Find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# Easier navigation: .., ..., ...., .....,
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git
alias amend="git add -A && git commit --amend --no-edit"
alias commit="git add -A && git commit -m"
alias ga='git add'
alias gaa='git add -A'
alias gb="git branch"
alias gc="git checkout"
alias gcmsg='git commit -m'
alias gf='git fetch'
alias gl="git log --oneline --decorate --color"
alias gpr='git pull --rebase'
alias gst="git status"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip='git commit -am "WIP"'

# pnpm
alias pn="pnpm"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Flush Directory Service (DNS) cache
alias flush="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'

# Benchmark zsh startup time
alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'

# Navigate to `~/.config/zsh/`
alias zdot='cd ${ZDOTDIR:-~}'

# Claude Code
alias claude-pool='source ~/.config/nas-fleet/env.sh && CLAUDE_CONFIG_DIR=$HOME/.claude-pool claude'
