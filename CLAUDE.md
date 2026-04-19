# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles. There is no build system, test suite, or linter — changes are validated by sourcing a shell or re-running the relevant install step. Everything here is installed onto a machine by symlinking into `$HOME` (not by copying), so edits to tracked files take effect on the live system the next shell session.

## Install / bootstrap

- `./fresh.sh` — one-shot machine setup. Installs Xcode CLT + Homebrew, initializes submodules, symlinks every subdir of `./.config/` to `~/.config/<name>`, symlinks `.config/zsh/.zshrc`, `.config/zsh/.zshenv`, `user.config/.gitconfig`, and `.gitignore_global` into `$HOME`, runs `brew bundle`, creates `~/Developer/work/crometrics` and `~/Developer/personal`, runs `./clone.sh`, then sources `./.macos`. Each symlink step refuses to clobber an existing non-symlink at the target and logs a warning instead, so re-runs are safe over prior installs but will NOT overwrite hand-edited config files — resolve those manually first.
- `./ssh.sh <email>` — generates an ed25519 key, writes `~/.ssh/config`, and adds the key to the agent. Run before `fresh.sh` on a fresh machine.
- `./clone.sh` — clones the CROmetrics repos into `~/Developer/work/crometrics/`.
- `brew bundle --file ./Brewfile` — reinstalls the full CLI/cask/mas set. Edit `Brewfile` to add dependencies; no autogeneration.

Reload shell config after editing: `exec zsh` (or `source ~/.zshrc`).

## Layout and conventions

```
.config/          → symlinked to ~/.config/*    (per-app XDG configs)
  zsh/            ZDOTDIR — all zsh config lives here, not in $HOME
  ghostty/ gh/ spaceship/ raycast/
user.config/      .gitconfig → ~/.gitconfig (symlinked by fresh.sh).
                  The identity fragments (.gitconfig-ryanzigler, .gitconfig-crometrics-code)
                  are NOT symlinked — .gitconfig references them at their in-repo path.
.gitignore_global → symlinked to ~/.gitignore_global by fresh.sh
.macos            macOS `defaults write` script, sourced at end of fresh.sh
Brewfile          Homebrew bundle manifest (brew/cask/mas)
```

### Zsh loading order (critical)

`.zshenv` (always loaded) → `.zprofile` (login) → `.zshrc` (interactive). All three live in `.config/zsh/` but only `.zshenv` and `.zshrc` are symlinked to `$HOME` by `fresh.sh`. `.zshenv` sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh`, which is why every other zsh file is found under `.config/zsh/`.

`.zshrc` flow:
1. Autoloads every file in `.zfunctions/` onto `fpath`.
2. Sources `.zstyles` for plugin configuration.
3. Bootstraps [antidote](https://github.com/mattmc3/antidote) into `.antidote/` if missing, then `antidote load` reads `.zsh_plugins.txt` and generates `.zsh_plugins.zsh` (gitignored — do not edit the generated file).
4. Sources every `*.zsh` in `.zshrc.d/` (aliases, brew init).
5. Appends gcloud, bun, iterm2 integrations.

To add a plugin: edit `.zsh_plugins.txt`. To add aliases/functions: drop a `*.zsh` in `.zshrc.d/` or an autoload function in `.zfunctions/`.

### Git identity switching

`user.config/.gitconfig` uses `includeIf "gitdir:~/Developer/<path>/"` to pick an identity file per clone location. Include paths are written as `~/dotfiles/user.config/.gitconfig-*` — git expands `~/` in include paths but does NOT expand env vars like `$DOTFILES_DIR`, so the literal `~/dotfiles` is intentional. If the repo is not at `~/dotfiles`, these includes will silently no-op. `fresh.sh` symlinks `user.config/.gitconfig` → `~/.gitconfig` to activate the mechanism.

`DOTFILES_DIR` is hardcoded to `$HOME/dotfiles` in `.zshenv`. `README.md` still instructs cloning to `~/.dotfiles` and is out of date — prefer `$HOME/dotfiles` when resolving paths.

## When editing

- Prefer putting new interactive config in `.zshrc.d/*.zsh` over editing `.zshrc` directly.
- Don't commit `.zsh_plugins.zsh`, `.zcompdump*`, or `.antidote/` — they're generated and gitignored. If `git status` shows them staged, the gitignore isn't taking effect and should be fixed first.
- Secrets don't belong in `.zshenv`; it's tracked and world-readable once pushed. If you find one, flag it and move it to a gitignored file sourced from `.zshenv`.
