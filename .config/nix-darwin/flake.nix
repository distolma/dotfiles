{
  description = "Dima's Darwin system flake";

  inputs = {
    # Nix package sources
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Darwin specific inputs
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew inputs
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      rust-overlay,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            _1password-cli
            bun
            curlie
            delta
            deno
            elixir
            eza
            fd
            fish
            fnm
            fzf
            git
            gleam
            go
            htop
            jq
            lazydocker
            lazygit
            mkcert
            nano
            neovim
            nixd
            nixfmt-rfc-style
            pnpm
            ripgrep
            rust-bin.stable.latest.default
            starship
            tinygo
            tmux
            uv
            wget
            zellij
            zoxide
          ];

          fonts = {
            packages = with pkgs; [
              nerd-fonts.jetbrains-mono
              jetbrains-mono
            ];
          };

          homebrew = {
            enable = true;
            taps = [ "sdkman/tap" ];
            brews = [ "sdkman/tap/sdkman-cli" ];
            casks = [
              "1password@7"
              "firefox"
              "ghostty"
              "languagetool"
              "meetingbar"
              "mockoon"
              "nvidia-geforce-now"
              "orbstack"
              "protonvpn"
              "rectangle"
              "setapp"
              "sublime-text"
              "virtualbox"
              "visual-studio-code"
              "yaak"
              "zed"
              "zen-browser"
              "keymapp"
            ];
            masApps = {
              "nordvpn" = 905953485;
            };

            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
            };
          };

          security.pam.services.sudo_local.touchIdAuth = true;

          system = {
            defaults = {
              dock = {
                tilesize = 50;
                autohide = true;
                mru-spaces = false;
                static-only = true;
                show-recents = false;
                expose-group-apps = false;
              };
              finder = {
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                FXPreferredViewStyle = "clmv";
              };
            };
          };

          # Auto upgrade nix package and the daemon service.
          # services.nix-daemon.enable = true;
          nix = {
            enable = true;
            package = pkgs.nix;
            settings = {
              "extra-experimental-features" = [
                "nix-command"
                "flakes"
              ];
            };
            nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          programs.fish.enable = false;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs = {
            overlays = [ rust-overlay.overlays.default ];
            hostPlatform = "aarch64-darwin";
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mac
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "dmostovyi";
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."mac".pkgs;
    };
}
