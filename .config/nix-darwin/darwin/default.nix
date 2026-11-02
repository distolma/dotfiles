{
  pkgs,
  config,
  inputs,
  nixpkgsInput,
  platform,
  username,
  ...
}:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./${username}
  ];

  nixpkgs.config.allowUnfree = true;

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
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

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Hard-link identical files in the store as they are written
      auto-optimise-store = true;
    };
    nixPath = [ "nixpkgs=${nixpkgsInput}" ];

    # Automatic garbage collection: delete generations older than 30 days
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      }; # Sundays at 03:00
      options = "--delete-older-than 30d";
    };
  };

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = platform == "aarch64-darwin";

    # User owning the Homebrew prefix
    user = username;

    # Non-official taps require explicit trust
    trust.taps = [
      "hashicorp/tap"
      "wouterdebie/tap"
    ];
  };

  # Third-party taps are tapped imperatively on activation;
  # homebrew-core/cask are served via the Homebrew API (no local taps)
  homebrew.taps = [
    "hashicorp/tap"
    "wouterdebie/tap"
  ];

  # Enable fish and make it the login shell
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  users.users.${username}.shell = pkgs.fish;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs = {
    overlays = [ inputs.rust-overlay.overlays.default ];
    hostPlatform = platform;
  };
}
