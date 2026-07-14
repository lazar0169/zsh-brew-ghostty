#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

echo "Starting setup (safe to re-run)..."

# --- Homebrew ---
info "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  log "installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "already installed"
fi
# Make sure brew is on PATH for the rest of this script.
if brew_path="$(brew_bin)"; then
  eval "$("$brew_path" shellenv)"
fi

# --- Oh My Zsh ---
info "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "installing Oh My Zsh..."
  # KEEP_ZSHRC=yes so the installer doesn't overwrite the .zshrc we deploy below.
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "already installed"
fi

# --- Config files (only rewritten when they differ; existing ones backed up) ---
info "Config files"
deploy_configs "$SCRIPT_DIR"

# --- Homebrew packages ---
info "Homebrew packages"
if brew bundle check --file="$SCRIPT_DIR/Brewfile" >/dev/null 2>&1; then
  log "all packages already installed"
else
  brew bundle --file="$SCRIPT_DIR/Brewfile"
fi

# nvm expects its working directory to exist
mkdir -p "$HOME/.nvm"

# --- Fix compinit insecure directories (Homebrew prefix) ---
info "compinit permissions"
ZSH_SHARE="$(brew --prefix)/share"
if [[ -d "$ZSH_SHARE" ]]; then
  chmod go-w "$ZSH_SHARE" || true
  [[ -d "$ZSH_SHARE/zsh" ]] && chmod -R go-w "$ZSH_SHARE/zsh" || true
  log "ok"
fi

# --- Default shell ---
info "Default shell"
ZSH_BIN="$(command -v zsh)"
if ! grep -q "$ZSH_BIN" /etc/shells; then
  log "adding $ZSH_BIN to /etc/shells (sudo may prompt)..."
  echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  log "changing default shell to $ZSH_BIN..."
  chsh -s "$ZSH_BIN"
else
  log "already $ZSH_BIN"
fi

info "Done"
log "Open a new terminal or run: source ~/.zshrc"
