return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "gemini",
    gemini = {
      model = "gemini-2.5-pro-exp-03-25",
    },
    file_selector = {
      provider = "snacks",
    },
  },
}
