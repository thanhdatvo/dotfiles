return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-go",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rust"),
        require("neotest-go")({
          experimental = {
            test_table = true, -- optional: support for table-driven tests
          },
        }),
      },
    })
  end,
}
