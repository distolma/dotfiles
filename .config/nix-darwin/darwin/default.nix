{
  pkgs,
  inputs,
  rust-overlay,
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

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
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

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = if (platform == "aarch64-darwin") then true else false;

    # User owning the Homebrew prefix
    user = "${username}";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs = {
    overlays = [ rust-overlay.overlays.default ];
    hostPlatform = platform;
  };
}
