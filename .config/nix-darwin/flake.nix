{
  description = "Dima's Darwin system flake for work and home machines";

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
      mkDarwinConfiguration = username: platform:
        nix-darwin.lib.darwinSystem {
          system = platform;
          specialArgs = {
            inherit inputs username platform rust-overlay;
          };
          modules = [
            ./darwin
            ./packages
          ];
        };
    in
    {
      darwinConfigurations = {
        "work" = mkDarwinConfiguration "dmostovyi" "aarch64-darwin";
        "home" = mkDarwinConfiguration "distolma" "x86_64-darwin";
      }; 
    };
}
