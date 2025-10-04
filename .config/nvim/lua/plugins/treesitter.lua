return {
  -- "neovim/nvim-lspconfig",
  -- opts = function()
  --   require("lspconfig").dartls.setup({
  --     cmd = { "dart", "language-server", "--protocol=lsp" },
  --   })
  -- end,
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  opts = {
    ensure_installed = {
      "svelte",
      "javascript",
      "typescript",
      "css",
      "html",
      "dart",
    },
    highlight = {
      enable = true,
    },
  },
}
