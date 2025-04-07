{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./${username}
  ];

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
    zig
    zoxide
  ];

  homebrew = {
    enable = true;
    casks = [
      "1password@7"
      "firefox"
      "ghostty"
      "keymapp"
      "nvidia-geforce-now"
      "orbstack"
      "protonvpn"
      "rectangle"
      "sublime-text"
      "virtualbox"
      "visual-studio-code"
      "zed"
    ];
    masApps = { };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}
