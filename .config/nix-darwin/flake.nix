{
  description = "Dima's Darwin system flake for work and home machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # nix-darwin dropped x86_64-darwin (Intel) support starting with 26.11.
    # Pin the Intel home machine to the last release branch that still supports it.
    nixpkgs-2605.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin-2605.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin-2605.inputs.nixpkgs.follows = "nixpkgs-2605";

    # Pinned Homebrew taps for declarative tap management via nix-homebrew.
    # Update with `nix flake update`.
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    # Provides herdr for the Intel home machine (not in nixpkgs-26.05)
    homebrew-wouterdebie = {
      url = "github:wouterdebie/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-2605,
      nix-darwin,
      nix-darwin-2605,
      ...
    }:
    let
      mkDarwinConfiguration =
        {
          username,
          platform,
          nix-darwin,
          nixpkgs,
        }:
        nix-darwin.lib.darwinSystem {
          system = platform;
          specialArgs = {
            inherit username platform inputs;
            # The nixpkgs flake input matching this machine's nix-darwin branch
            nixpkgsInput = nixpkgs;
          };
          modules = [
            ./darwin
            ./packages
          ];
        };
    in
    {
      darwinConfigurations = {
        "work" = mkDarwinConfiguration {
          username = "dmostovyi";
          platform = "aarch64-darwin";
          inherit nix-darwin nixpkgs;
        };
        "home" = mkDarwinConfiguration {
          username = "distolma";
          platform = "x86_64-darwin";
          nix-darwin = nix-darwin-2605;
          nixpkgs = nixpkgs-2605;
        };
      };
    };
}
