_: {
  homebrew = {
    brews = [
      "awscli"
      "hashicorp/tap/vault"
      # Apple Silicon only; not installed on the Intel home machine
      "herdr"
      "opencode"
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
      # Apple Silicon only; not installed on the Intel home machine
      "whatcable"
    ];
  };
}
