# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/antigen.zsh


## Use oh-my-zsh
antigen use oh-my-zsh

## Plugins

antigen bundle git
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle lukechilds/zsh-better-npm-completion

## NVM Plugin with lazy loading
export NVM_LAZY_LOAD=true
antigen bundle lukechilds/zsh-nvm


## Adds tips for remembering defined aliases
antigen bundle djui/alias-tips


## Load a custom Theme
#antigen theme spaceship-prompt/spaceship-prompt
antigen theme romkatv/powerlevel10k

## Syntax Highlighting Settings
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
#ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red') # To have commands starting with `rm -rf` in red:
#ZSH_HIGHLIGHT_STYLES[default]='none'
#ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=009'
#ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=009,standout'
#ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'
#ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
#ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'
#ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
#ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,underline'
#ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
#ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=009'
#ZSH_HIGHLIGHT_STYLES[path]='fg=214,underline'
#ZSH_HIGHLIGHT_STYLES[globbing]='fg=063'
#ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=white,underline'
#ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='none'
#ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='none'
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
#ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=063'
#ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=063'
#ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=009'
#ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=009'
#ZSH_HIGHLIGHT_STYLES[assign]='none'

## Syntax Highlighting for ZSH
### LOAD AS LAST ANTIGEN BUNDLE ###
#antigen bundle zsh-users/zsh-syntax-highlighting

# 3. Commit Antigen Configuration
antigen apply

source $HOME/.aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"