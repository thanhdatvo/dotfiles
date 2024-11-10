return {
  -- "neovim/nvim-lspconfig",
  -- opts = function()
  --   require("lspconfig").dartls.setup({
  --     cmd = { "dart", "language-server", "--protocol=lsp" },
  --   })
  -- end,
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "dart" }, -- add "dart" here
      highlight = {
        enable = true, -- enable Treesitter-based highlighting
      },
    })
  end,
}
