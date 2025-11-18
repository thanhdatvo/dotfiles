return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    "nvim-neotest/neotest-go",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true, -- optional: support for table-driven tests
          },
        }),
        require("rustaceanvim.neotest")({
          -- test_command = function(test_args)
          --   -- test_args normally looks like { "test", "--nocapture", "some_test_name" }
          --   -- We replace "cargo test" with "cargo nextest run"
          --   return vim.list_extend({ "cargo", "nextest", "run" }, test_args)
          -- end,
          args = { "--features", "test-support" },
        }),
      },
    })
  end,
}
