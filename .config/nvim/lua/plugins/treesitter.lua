return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {},
  run = ":TSUpdate",
  opts = {
    ensure_installed = {
      "svelte",
      "javascript",
      "typescript",
      "css",
      "html",
      "dart",
      "ripple",
    },
    highlight = {
      -- enable = false,
    },
  },
}
