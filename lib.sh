#!/usr/bin/env bash
# Shared helpers for install.sh / check.sh. Source this file; do not run it.

log()  { printf '  %s\n' "$*"; }
info() { printf '\n==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

# brew_bin — print the path to the brew binary if present (exit 1 otherwise).
brew_bin() {
  if command -v brew >/dev/null 2>&1; then command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then echo /opt/homebrew/bin/brew
  else return 1; fi
}

# sync_file SRC DEST
# Copy SRC -> DEST only when their contents differ. An existing, differing DEST
# is first backed up to DEST.bak-<timestamp>. Set DRY_RUN=1 to report the action
# without touching anything. Idempotent: identical files are left untouched.
sync_file() {
  local src="$1" dest="$2" pretty="${2/#$HOME/~}"
  [[ -f "$src" ]] || { warn "missing source: $src"; return 0; }
  if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
    log "unchanged  $pretty"
    return 0
  fi
  if [[ -e "$dest" ]]; then
    if [[ "${DRY_RUN:-0}" == 1 ]]; then log "would UPDATE $pretty (differs)"; return 0; fi
    local backup="$dest.bak-$(date +%Y%m%d%H%M%S)"
    cp "$dest" "$backup"
    cp "$src" "$dest"
    log "updated    $pretty (backup: ${backup/#$HOME/~})"
  else
    if [[ "${DRY_RUN:-0}" == 1 ]]; then log "would CREATE $pretty"; return 0; fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    log "created    $pretty"
  fi
}

# sync_tree SRC_DIR DEST_DIR — sync every file under SRC_DIR into DEST_DIR.
sync_tree() {
  local src="$1" dest="$2" f rel
  [[ -d "$src" ]] || { warn "missing source dir: $src"; return 0; }
  while IFS= read -r -d '' f; do
    rel="${f#"$src"/}"
    sync_file "$f" "$dest/$rel"
  done < <(find "$src" -type f -print0)
}

# deploy_configs REPO_DIR — sync every tracked dotfile into $HOME.
deploy_configs() {
  local repo="$1"
  sync_file "$repo/.zshrc"    "$HOME/.zshrc"
  sync_file "$repo/.zprofile" "$HOME/.zprofile"
  sync_file "$repo/.vimrc"    "$HOME/.vimrc"
  sync_tree "$repo/.config/ghostty" "$HOME/.config/ghostty"
}
