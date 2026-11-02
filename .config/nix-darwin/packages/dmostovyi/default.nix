{ pkgs, ... }:
{
  # herdr is only packaged in nixpkgs-unstable (work machine).
  # On the Intel home machine it is installed via brew instead.
  environment.systemPackages = [ pkgs.herdr ];

  homebrew = {
    brews = [
      "awscli"
      "hashicorp/tap/vault"
    ];
    casks = [
      "claude"
      "deskpad"
      "figma"
      "fluidvoice"
      "intellij-idea-ce"
      "languagetool-desktop"
      "meetingbar"
      "mockoon"
      "orbstack"
      "postman"
    ];
  };
}
