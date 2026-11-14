# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles. There is no build system, test suite, or linter — changes are validated by sourcing a shell or re-running the relevant install step. Everything here is installed onto a machine by symlinking into `$HOME` (not by copying), so edits to tracked files take effect on the live system the next shell session.

## Install / bootstrap

- `./fresh.sh` — one-shot machine setup. Installs Xcode CLT + Homebrew, initializes submodules, symlinks every subdir of `./.config/` to `~/.config/<name>`, symlinks `.config/zsh/.zshrc`, `.config/zsh/.zshenv` and `.gitignore_global` into `$HOME`, adds an `[include]` of `user.config/.gitconfig` to `~/.gitconfig`, runs `brew bundle`, creates `~/Developer/work/crometrics` and `~/Developer/personal`, runs `./clone.sh`, and, only when passed `--macos`, sources `./.macos`. It `cd`s to the repo root first, so it can be invoked from any directory. Each symlink step refuses to clobber an existing non-symlink at the target and logs a warning instead, so it will NOT overwrite hand-edited config files — resolve those manually first. `.macos` is opt-in because it asks for sudo, resets the computer name and timezone, appends another Dock spacer, and kills Finder, Dock, Safari, Chrome, Mail and Messages. Without `--macos`, re-running `fresh.sh` on a machine in use is safe.
- `./ssh.sh <email>` — generates an ed25519 key, writes `~/.ssh/config` if there isn't one (an existing config is left untouched), and adds the key to the agent. Run before `fresh.sh` on a fresh machine.
- `./clone.sh` — clones the CROmetrics repos into `~/Developer/work/crometrics/`, skipping any that already exist.
- `brew bundle --file ./Brewfile` — reinstalls the full CLI/cask/mas set. Edit `Brewfile` to add dependencies; no autogeneration.

Reload shell config after editing: `exec zsh` (or `source ~/.zshrc`).

## Layout and conventions

```
.config/          → symlinked to ~/.config/*    (per-app XDG configs)
  zsh/            ZDOTDIR — all zsh config lives here, not in $HOME
  ghostty/ gh/
  starship.toml   a file, so NOT symlinked (fresh.sh links directories only);
                  .zshenv points STARSHIP_CONFIG at it inside the repo
user.config/      .gitconfig is pulled into ~/.gitconfig by an [include] that fresh.sh adds;
                  it is not symlinked. The identity fragment (.gitconfig-ryanzigler) is
                  referenced from .gitconfig at its in-repo path. *.local files in this
                  directory are gitignored, machine-local fragments.
.gitignore_global → symlinked to ~/.gitignore_global by fresh.sh
.macos            macOS `defaults write` script, sourced at end of fresh.sh
Brewfile          Homebrew bundle manifest (brew/cask/mas)
```

### Zsh loading order (critical)

`.zshenv` (always loaded) → `.zshrc` (interactive). There is no `.zprofile`; nothing needs a login-only hook. Both live in `.config/zsh/` and are symlinked to `$HOME` by `fresh.sh`. `.zshenv` sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh`, which is why every other zsh file is found under `.config/zsh/`.

Two things make that less simple than it looks:

- Cursor/VS Code integrated terminals source `~/.zshenv` and `~/.zshrc` with `ZDOTDIR=$HOME`. Neither file may locate its siblings through `$ZDOTDIR`; both resolve their own real directory instead (`${${(%):-%x}:A:h}`). Keep it that way.
- In login shells, macOS's `/etc/zprofile` runs `path_helper` after `.zshenv`, which moves the system directories ahead of everything `.zshenv` added. The order written in `.zshenv` is therefore not the final order; only what `.zshrc` and `.zshrc.d/` prepend afterwards (Homebrew, Vite+, `~/.local/bin`) reliably ends up in front.

`.zshrc` flow:
1. Autoloads every file in `.zfunctions/` onto `fpath`.
2. Sources `.zstyles` for plugin configuration.
3. Initialises the [antidote](https://github.com/mattmc3/antidote) submodule in `.antidote/` if it is missing, regenerates `.zsh_plugins.zsh` with `antidote bundle` only when `.zsh_plugins.txt` is newer, and sources it (static mode; the generated file is gitignored — do not edit it). `antidote` itself is lazy-loaded on first use.
4. Sources every `*.zsh` in `.zshrc.d/` in alphabetical order (aliases, brew, completions, conda, gcloud, history, starship, vite-plus). This runs after the plugins, so it is where anything that must override a plugin goes — `history.zsh` exists because the history plugin sets `HISTSIZE`/`SAVEHIST` and `INC_APPEND_HISTORY` itself.
5. Raises `ulimit -n` and puts `~/.local/bin` first on `PATH`.

`brew.zsh` and `starship.zsh` cache their init output under `$XDG_CACHE_HOME` and refresh it when the binary is newer than the cache; delete the cache file to force a refresh. `conda.zsh` sources conda's own `etc/profile.d/conda.sh` instead of running `conda shell.zsh hook`, so it never activates `base` on its own.

To add a plugin: edit `.zsh_plugins.txt`. To add aliases/functions: drop a `*.zsh` in `.zshrc.d/` or an autoload function in `.zfunctions/`.

### Git identity switching

`user.config/.gitconfig` uses `includeIf "gitdir:<path>/"` (for `~/dotfiles`, `~/Developer/personal` and `~/Developer/work`) to pick an identity file per clone location. Include paths are written as `~/dotfiles/user.config/.gitconfig-*` — git expands `~/` in include paths but does NOT expand env vars like `$DOTFILES_DIR`, so the literal `~/dotfiles` is intentional. If the repo is not at `~/dotfiles`, these includes will silently no-op. `fresh.sh` adds `[include] path = ~/dotfiles/user.config/.gitconfig` to `~/.gitconfig` to activate the mechanism.

`DOTFILES_DIR` defaults to `$HOME/dotfiles` in `.zshenv`, and the include paths above hardcode `~/dotfiles`, so the repo has to be cloned there.

`~/.gitconfig` itself is a machine-local, untracked file: the include, whatever tools append (credential helpers and the like), and anything that should stay out of this public repo. It used to be a symlink to the tracked file, which broke whenever a tool rewrote it. Settings meant to be shared across machines go in `user.config/.gitconfig`.

## When editing

- Prefer putting new interactive config in `.zshrc.d/*.zsh` over editing `.zshrc` directly.
- Don't commit `.zsh_plugins.zsh` or `.zcompdump*` — they're generated and gitignored. If `git status` shows them staged, the gitignore isn't taking effect and should be fixed first. `.antidote/` is different: it is a pinned git submodule, so bump it deliberately.
- Don't run `shfmt` over the zsh files without reading its diff. It parses them as bash and rewrites subscripts such as `$+functions[zsh-defer]` into `$+functions[zsh - defer]`, which is always false and fails silently.
- Secrets don't belong in `.zshenv`; it's tracked and the GitHub repo is public. If you find one, flag it and move it to `.config/zsh/.zshenv.local`, which is gitignored and sourced at the end of `.zshenv`.
