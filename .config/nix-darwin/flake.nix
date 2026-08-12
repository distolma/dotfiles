{
  description = "Dima's Darwin system flake for work and home machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # nix-darwin dropped x86_64-darwin (Intel) support starting with 26.11.
    # Pin the Intel home machine to the last release branch that still supports it.
    nixpkgs-2605.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin-2605.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin-2605.inputs.nixpkgs.follows = "nixpkgs-2605";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-darwin-2605,
      nixpkgs-2605,
      nix-homebrew,
      rust-overlay,
    }:
    let
      mkDarwinConfiguration =
        username: platform: darwin: nixpkgs:
        darwin.lib.darwinSystem {
          system = platform;
          specialArgs = {
            inherit
              username
              platform
              rust-overlay
              ;
            inputs = inputs // { inherit nixpkgs; };
          };
          modules = [
            ./darwin
            ./packages
          ];
        };
    in
    {
      darwinConfigurations = {
        "work" = mkDarwinConfiguration "dmostovyi" "aarch64-darwin" nix-darwin nixpkgs;
        "home" = mkDarwinConfiguration "distolma" "x86_64-darwin" nix-darwin-2605 nixpkgs-2605;
      };
    };
}
