# Brew
eval $(/opt/homebrew/bin/brew shellenv)
export PATH="/opt/homebrew/bin:${PATH}"

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Starship
eval "$(starship init zsh)"

# Colors
autoload -U colors && colors

# Completion
autoload -Uz compinit && compinit

# fzf
eval "$(fzf --zsh)"

# Aliases
alias ..='cd ..'
alias l='eza --all'
alias ll='eza --long --all --git --header --icons --group-directories-first --links'
alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox"
alias brewdeps="brew leaves | xargs brew deps --include-build --tree"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# fnm
eval "$(fnm env --use-on-cd)"

firedep() {
  npx --yes firebase-tools hosting:channel:deploy $1
}

op_load_secrets() {
  local template="$HOME/.config/zsh/secrets.template"
  local secrets="$HOME/.config/zsh/secrets.zsh"

  # If secrets.zsh does not exist, create it
  if [ ! -f $secrets ]; then
    # Check if signed in
    if ! op whoami &> /dev/null; then
      echo "Signing in to 1Password..." >&2
      eval $(op signin)
    fi

    echo "Getting secrets..."
    op inject --in-file $template --out-file $secrets
  fi
  source $secrets
}

op_load_secrets
