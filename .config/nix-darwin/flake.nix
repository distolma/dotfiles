{
  description = "Dima's Darwin system flake for work and home machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
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
          username = "dmytromostovyi";
          platform = "aarch64-darwin";
          inherit nix-darwin nixpkgs;
        };
      };
    };
}
