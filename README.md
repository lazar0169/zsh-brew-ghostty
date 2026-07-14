# Zsh + Homebrew Setup

A simple guide and configuration reference for setting up a modern Zsh environment with syntax highlighting, autosuggestions, and a clean prompt.

---

## ⚙️ What This Setup Includes

This setup gives you:

- **Zsh** as your default shell
- **Oh My Zsh** for shell management
- **Syntax highlighting** (`zsh-syntax-highlighting`)
- **Autosuggestions** (`zsh-autosuggestions`)
- **History substring search** (`history-substring-search`)
- A **minimal theme** (`agnoster`, or Powerlevel10k if you prefer later)
- **JetBrains Mono Nerd Font** (installed via the `Brewfile`) — used by Ghostty
  and recommended for VS Code

---

## 🚀 Install

```bash
./install.sh
```

This bootstraps Homebrew (if missing), installs Oh My Zsh, copies `.zshrc`,
`.zprofile`, `.vimrc`, and the Ghostty config (`.config/ghostty/`) into your
home directory, installs everything in the `Brewfile` via `brew bundle`, and
sets Zsh as your default shell.

**Safe to re-run.** The installer is idempotent:

- Config files are only rewritten when their contents actually differ, and any
  existing file is backed up to `*.bak-<timestamp>` before being replaced — so
  re-running on an up-to-date machine changes nothing.
- Homebrew and Oh My Zsh are installed only when missing; `brew bundle` skips
  packages that are already present.

### Preview changes first

```bash
./check.sh
```

`check.sh` is a dry run: it reports exactly what `install.sh` would install,
update, or leave untouched, without modifying anything. Shared logic lives in
`lib.sh`, which both scripts source.

### Brewfile

`Brewfile` captures the machine's Homebrew setup — formulae (git, nvm, pyenv,
mongosh, the zsh plugins) and casks (ghostty, VS Code, orbstack, Raycast, and
the rest). Only packages installed on request (`brew leaves`) are listed;
Homebrew resolves dependencies (node, openssl@3, icu4c, readline, …)
automatically.

Install or update everything on its own with:
```bash
brew bundle --file=./Brewfile
```

Docker isn't installed directly — **orbstack** provides the `docker` CLI used by
the aliases and the `docker` Oh My Zsh plugin.

---

## 🧩 Font Configuration for VS Code

The `Brewfile` installs JetBrains Mono Nerd Font. Wire it up in VS Code:
```json
{
  "terminal.integrated.fontFamily": "JetBrains Mono Nerd Font",
  "editor.fontFamily": "JetBrains Mono NL, SF Mono, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "terminal.integrated.fontSize": 13
}
```
