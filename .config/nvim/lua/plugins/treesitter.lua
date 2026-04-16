return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {},
  run = ":TSUpdate",
  opts = {
    ensure_installed = {
      "python",
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
