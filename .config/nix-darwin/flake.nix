{
  description = "Dima's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
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
            nixfmt-rfc-style
            nixd
            neovim
            tmux
            go
            tinygo
            elixir
            starship
            git
            delta
            fnm
            fzf
            eza
            htop
            nano
            mkcert
            jq
            wget
            zoxide
            zellij
            ripgrep
            lazygit
            lazydocker
            rust-bin.stable.latest.default
            pnpm
            bun
            deno
            zig
            uv
            curlie
          ];

          fonts = {
            packages = with pkgs; [
              jetbrains-mono
              nerd-fonts.jetbrains-mono
            ];
          };

          homebrew = {
            enable = true;
            brews = [ "gleam" ];
            casks = [
              "1password@7"
              "meetingbar"
              "orbstack"
              "setapp"
              "virtualbox@beta"
              "yaak"
              "adobe-acrobat-reader"
              "firefox"
              "languagetool"
              "mockoon"
              "rectangle"
              "sublime-text"
              "visual-studio-code"
              "zed"
              "nvidia-geforce-now"
              "ghostty"
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

          security.pam.enableSudoTouchIdAuth = true;

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
          services.nix-daemon.enable = true;
          nix = {
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
          # programs.fish.enable = true;

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
