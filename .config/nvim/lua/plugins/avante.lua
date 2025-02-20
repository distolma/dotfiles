return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  build = "make",
  opts = {
    provider = "claude",
    gemini = {
      model = "gemini-2.0-flash",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "echasnovski/mini.icons",
    "stevearc/dressing.nvim",
  },
}
