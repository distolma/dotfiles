{
  pkgs,
  ...
}:
{
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
    fnm
    fzf
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
    brews = [ "gleam" ];
    casks = [
      "1password@7"
      "firefox"
      "ghostty"
      "keymapp"
      "languagetool"
      "meetingbar"
      "mockoon"
      "nvidia-geforce-now"
      "orbstack"
      "protonvpn"
      "rectangle"
      "setapp"
      "sublime-text"
      "virtualbox"
      "visual-studio-code"
      "yaak"
      "zed"
    ];
    masApps = {
      "nordvpn" = 905953485;
    };

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}
