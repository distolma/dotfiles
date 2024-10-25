return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      nixd = {
        cmd = { "nixd" },
        filetypes = { "nix" },
        settings = {
          nixd = {
            nixpkgs = {
              expt = "import nixpkgs { }",
            },
            formatting = {
              command = "nixfmt",
            },
          },
        },
      },
    },
  },
}
