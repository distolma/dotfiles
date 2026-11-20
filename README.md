# Install

1. Install [Nix](https://nixos.org/download/)

```sh
sh <(curl -L https://nixos.org/nix/install)
```

2. Clone the repository and navigate to it
3. Stow config files using Nix packages

```sh
nix --extra-experimental-features "nix-command flakes" run nixpkgs#stow .
```

4. Install [nix-darwin](https://github.com/LnL7/nix-darwin)

```sh
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-darwin
```

5. Use `nix-darwin`

```sh
darwin-rebuild switch --flake ~/.config/nix-darwin
```
