return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("flutter-tools").setup({
      debugger = {
        enabled = true,
        register_configurations = function(paths)
          -- local dap = require("dap")
          -- dap.configurations.dart = {}
          require("dap.ext.vscode").load_launchjs()
        end,
      },
      dev_log = {
        enabled = false,
      },
      settings = {
        dart = {
          analysisExcludedFolders = {
            vim.fn.expand("$PWD/android"),
            vim.fn.expand("$PWD/ios"),
            vim.fn.expand("$PWD/web"),
          },
        },
      },
    })
  end,
}
