function bw_load_secrets --description 'Inject Bitwarden secrets and load them into the shell'
    set -l template "$HOME/.config/fish/secrets.template"
    set -l secrets "$HOME/.config/fish/secrets.fish"
    set -l session_file "$HOME/.config/fish/.bw_session"

    # Reuse a saved session key if the vault is unlocked
    if test -z "$BW_SESSION"; and test -f $session_file
        set -gx BW_SESSION (cat $session_file)
    end

    # If secrets.fish does not exist, create it
    if not test -f $secrets
        if not bw login --check &>/dev/null
            echo "Logging in to Bitwarden..." >&2
            bw login
        end

        if test -z "$BW_SESSION"; or not bw sync &>/dev/null
            echo "Unlocking Bitwarden..." >&2
            set -gx BW_SESSION (bw unlock --raw)
            test -n "$BW_SESSION"; and printf '%s' $BW_SESSION >$session_file
        end

        echo "Getting secrets..." >&2
        set -l text (cat $template)
        for ref in (string match -ar 'bw://[^"]+' $text | sort -u)
            set -l parts (string split -m1 / (string sub -s 6 -- $ref))
            set -l value (bw get $parts[2] "$parts[1]")
            if test -z "$value"
                echo "Failed to fetch $ref" >&2
                return 1
            end
            set text (string replace -- $ref $value $text)
        end

        set -l old_umask (umask)
        umask 077
        printf '%s\n' $text >$secrets
        umask $old_umask
    end

    source $secrets
end
