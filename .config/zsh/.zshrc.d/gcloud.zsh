_gcloud_sdk=$HOME/google-cloud-sdk
[[ -d $_gcloud_sdk ]] || { unset _gcloud_sdk; return 0 }

# PATH stays inline — it's one line and needed for `gcloud` to resolve immediately.
[[ -f $_gcloud_sdk/path.zsh.inc ]] && source $_gcloud_sdk/path.zsh.inc

# Completion is 60+ lines and not needed until the user tab-completes.
# Defer it if zsh-defer is available (pulled in by antidote via kind:defer bundles).
if [[ -f $_gcloud_sdk/completion.zsh.inc ]]; then
  if (( $+functions[zsh-defer] )); then
    zsh-defer source $_gcloud_sdk/completion.zsh.inc
  else
    source $_gcloud_sdk/completion.zsh.inc
  fi
fi

unset _gcloud_sdk
