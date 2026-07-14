# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
export HOMEBREW_UPGRADE_GREEDY=1
ZSH_DISABLE_COMPFIX=true

# Load NVM into shell
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# Theme (change this to 'agnoster' or 'powerlevel10k' for git branch/status)
# ZSH_THEME="awesomepanda"
ZSH_THEME="agnoster"
DEFAULT_USER=$USER

# Auto-update settings
zstyle ':omz:update' mode auto

# Enable plugins
plugins=(
  git
  docker
  asdf
  history-substring-search
)
source $ZSH/oh-my-zsh.sh

# --- HOMEBREW COMPLETIONS ---
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  # Cache compinit for faster startup
  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
    compinit
  else
    compinit -C
  fi
fi

# --- AUTOSUGGESTIONS ---
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- SYNTAX HIGHLIGHTING (must come last) ---
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

cleanup-git() {
  echo "Fetching and pruning remotes..."
  git fetch -p
  gone_branches=$(git branch -vv | grep ': gone]' | awk '{print $1}')
  if [ -z "$gone_branches" ]; then
    echo "No stale branches found."
    return
  fi
  echo "Force deleting the following branches:"
  echo "$gone_branches"
  echo
  echo "$gone_branches" | xargs -r git branch -D
  echo "🔥 Force cleanup complete."
}

# --- ALIASES ---
alias list="ls -lah"
alias p="python3"
alias pip3="pip"
alias cleanup-node-modules='find . -name node_modules -type d -prune -exec rm -rf {} +'
alias docker-up='docker compose down && docker compose up -d'

# --- NVM ---
# NVM is lazy-loaded in .zprofile to improve startup time

# --- PYENV ---
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# Lazy load pyenv to improve startup time
if command -v pyenv 1>/dev/null 2>&1; then
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
fi

# --- CHROME EXECUTABLE ---
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

# --- HOMEBREW BIN ---
export PATH="/opt/homebrew/bin:$PATH"

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
