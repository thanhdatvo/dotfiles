return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
    "mfussenegger/nvim-dap",
  },
  -- config = true,
  config = function()
    local dap = require("dap")
    dap.adapters.flutter = {
      type = "executable",
      command = "fvm",
      args = { "flutter", "debug_adapter" },
    }
    dap.adapters.dart = {
      type = "executable",
      command = "fvm",
      -- args = { "dart", "debug_adapter" },

      args = { "flutter", "debug_adapter" },
    }
    require("flutter-tools").setup_project({
      -- name = "Web",
      -- device = "chrome",
      -- web_port = "3000",
      -- additional_args = { "--wasm" },
    })
    require("flutter-tools").setup({
      fvm = true,
      debugger = {
        enabled = true,
        register_configurations = function(paths)
          require("dap.ext.vscode").load_launchjs()
        end,
        -- register_configurations = function(_)
        --   -- dap.configurations.dart = {
        --   --   {
        --   --     type = "dart",
        --   --     request = "launch",
        --   --     name = "Flutter Chrome",
        --   --     dartSdkPath = "fvm/flutter_sdk/bin/cache/dart-sdk/bin/dart",
        --   --     flutterSdkPath = "fvm/flutter_sdk",
        --   --     program = "${workspaceFolder}/lib/main.dart",
        --   --     cwd = "${workspaceFolder}",
        --   --     toolArgs = {
        --   --       "-d",
        --   --       "chrome",
        --   --       "--web-experimental-hot-reload",
        --   --     },
        --   --   },
        --   --   {
        --   --     type = "dart",
        --   --     request = "launch",
        --   --     name = "Flutter macOS",
        --   --     dartSdkPath = "fvm/flutter_sdk/bin/cache/dart-sdk/bin/dart",
        --   --     flutterSdkPath = "fvm/flutter_sdk",
        --   --     program = "${workspaceFolder}/lib/main.dart",
        --   --     cwd = "${workspaceFolder}",
        --   --     toolArgs = {
        --   --       "-d",
        --   --       "macos",
        --   --     },
        --   --   },
        --   -- }
        -- end,
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
