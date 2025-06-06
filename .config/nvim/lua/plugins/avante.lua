return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "gemini",
    providers = {
      gemini = {
        model = "gemini-2.5-pro-preview-06-05",
      },
    },
    file_selector = {
      provider = "snacks",
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    { "stevearc/dressing.nvim", optional = true },
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  specs = {
    {
      "Kaiser-Yang/blink-cmp-avante",
      lazy = true,
      specs = {
        {
          "Saghen/blink.cmp",
          optional = true,
          opts = {
            sources = {
              default = { "avante" },
              providers = {
                avante = { module = "blink-cmp-avante", name = "Avante" },
              },
            },
          },
        },
      },
    },
  },
}
