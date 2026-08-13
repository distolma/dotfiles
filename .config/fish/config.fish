# Brew
/opt/homebrew/bin/brew shellenv fish | source
set -gx HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS 1

# Editor
set -gx EDITOR nvim

# PATH
fish_add_path $HOME/.local/bin
fish_add_path /run/current-system/sw/bin

# Work related 
source ~/.config/fish/work.fish 2>/dev/null

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

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
