# Brew
/opt/homebrew/bin/brew shellenv fish | source

# Editor
set -gx EDITOR nvim

# PATH
fish_add_path $HOME/.local/bin
fish_add_path /run/current-system/sw/bin

# Environment
set -gx GOOGLE_CLOUD_PROJECT sift-developer-infr
set -gx CLOUD_ML_REGION global
set -gx CLAUDE_CODE_USE_VERTEX 1
set -gx ANTHROPIC_MODEL "claude-sonnet-4-6@default"
set -gx ANTHROPIC_SMALL_FAST_MODEL "claude-haiku-4-5@20251001"
set -gx ANTHROPIC_VERTEX_PROJECT_ID sift-developer-infr
set -gx NODE_EXTRA_CA_CERTS "/Library/Application Support/Netskope/STAgent/data/nscacert.pem"

# 1Password secrets (loaded in all sessions)
op_load_secrets

if status is-interactive
    # Disable welcome message
    set -g fish_greeting

    # Starship
    starship init fish | source

    # fzf
    fzf --fish | source

    # zoxide (replaces cd)
    zoxide init --cmd cd fish | source

    # mise
    mise activate fish | source

    # Aliases
    alias ..='cd ..'
    alias l='eza --all'
    alias ll='eza --long --all --git --header --icons --group-directories-first --links'
    alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
    alias chrome-debug='open -a "Google Chrome" --args --remote-debugging-port=9222'
    alias brewdeps='brew leaves | xargs brew deps --include-build --tree'
end
