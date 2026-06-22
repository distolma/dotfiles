function op_load_secrets --description 'Inject 1Password secrets and load them into the shell'
    set -l template "$HOME/.config/fish/secrets.template"
    set -l secrets "$HOME/.config/fish/secrets.fish"

    # If secrets.fish does not exist, create it
    if not test -f $secrets
        # Check if signed in
        if not op whoami &>/dev/null
            echo "Signing in to 1Password..." >&2
            op signin | source
        end

        echo "Getting secrets..."
        op inject --in-file $template --out-file $secrets
    end

    source $secrets
end
