return {
  -- "neovim/nvim-lspconfig",
  -- opts = function()
  --   require("lspconfig").dartls.setup({
  --     cmd = { "dart", "language-server", "--protocol=lsp" },
  --   })
  -- end,
  "nvim-treesitter/nvim-treesitter",

  dependencies = {
    -- "Ripple-TS/ripple",
  },
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
      enable = true,
    },
  },
  -- config = function()
  --   require("ripple").setup()
  -- end,
}
