return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      markdown = { "prettier" },
      ripple = { "prettier" }, -- ✅ add this line
      python = { "ruff_format" },
    },
  },
}
