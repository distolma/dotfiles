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
    elixir
    eza
    fd
    fish
    fzf
    gdu
    gh
    git
    go
    google-cloud-sdk
    helix
    htop
    jq
    lazydocker
    lazygit
    mise
    mkcert
    nano
    neovim
    nixd
    nixfmt
    npkill
    pipx
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
      "opencode"
    ];
    casks = [
      "1password@7"
      "claude-code"
      "firefox"
      "ghostty"
      "keymapp"
      "protonvpn"
      "rectangle"
      "sublime-text"
      "tablepro"
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
