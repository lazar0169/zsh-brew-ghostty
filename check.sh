#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

echo "Dry run — reporting what install.sh would do. Nothing is modified."

info "Homebrew"
if command -v brew >/dev/null 2>&1; then
  log "installed ($(brew --version | head -1))"
else
  log "would install"
fi

info "Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  log "installed"
else
  log "would install"
fi

info "Config files"
DRY_RUN=1 deploy_configs "$SCRIPT_DIR"

info "Homebrew packages"
if command -v brew >/dev/null 2>&1; then
  if brew bundle check --verbose --file="$SCRIPT_DIR/Brewfile"; then
    log "all satisfied"
  fi
else
  log "brew not installed — cannot check Brewfile"
fi

info "Default shell"
ZSH_BIN="$(command -v zsh || true)"
if [[ -n "$ZSH_BIN" && "$SHELL" == "$ZSH_BIN" ]]; then
  log "already $ZSH_BIN"
else
  log "would change to ${ZSH_BIN:-zsh (not found)}"
fi
