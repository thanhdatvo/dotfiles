return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  config = function()
    require("flutter-tools").setup({
      debugger = {
        enabled = true,
        register_configurations = function(paths)
          local dap = require("dap")
          dap.configurations.dart = {}
          require("dap.ext.vscode").load_launchjs()
        end,
      },
    })
  end,
}
