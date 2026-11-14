#
# History overrides.
#
# These live in .zshrc.d so they run after the belak/zsh-utils history plugin,
# which sets HISTFILE (to $XDG_DATA_HOME/zsh/history), HISTSIZE/SAVEHIST=10000
# and INC_APPEND_HISTORY. Anything set before the plugin loads is silently overwritten.
#

HISTSIZE=100000
SAVEHIST=100000

# Writes each entry as: <epoch>:<elapsed>;<command> (e.g. 1726502400:10;ls -la)
setopt EXTENDED_HISTORY

# Write each command when it finishes, so <elapsed> is recorded and a crashed or force-quit terminal loses at most the command that was still running.
unsetopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
