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
    beamPackages.elixir
    bun
    croc
    curlie
    delta
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
    pi-coding-agent
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
      "mole"
      "opencode"
    ];
    casks = [
      "1password"
      "android-platform-tools"
      "claude-code"
      "firefox"
      "ghostty"
      "keymapp"
      "rectangle"
      "sublime-text"
      "tablepro"
      "whatcable"
      "visual-studio-code"
      "vlc"
      "zed"
    ];
    masApps = { };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "zap";
    };
  };
}
