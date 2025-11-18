return {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach", -- optional: only load after LSP attaches
  opts = {
    autocmd = { enabled = true },
    sign = {
      enabled = false,
    },
    virtual_text = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("nvim-lightbulb").setup(opts)
  end,
}
