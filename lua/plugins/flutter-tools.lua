return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("flutter-tools").setup_project({
      {
        additional_args = { "--web-experimental-hot-reload" },
      },
    })
    require("flutter-tools").setup({
      fvm = true,
      debugger = {
        enabled = true,
        register_configurations = function(paths)
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
            vim.fn.expand("$PWD/build"),
            vim.fn.expand("$PWD/.dart_tool"),
            vim.fn.expand("$PWD/.idea"),
            vim.fn.expand("$PWD"),
          },
        },
      },
    })
  end,
}
