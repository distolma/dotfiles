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
    gdu
    git
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
    npkill
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
    brews = [
      "sst/tap/opencode"
    ];
    taps = [
      "sst/tap"
    ];
    casks = [
      "1password@7"
      "firefox"
      "ghostty"
      "keymapp"
      "protonvpn"
      "rectangle"
      "sublime-text"
      "visual-studio-code"
      "vlc"
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
