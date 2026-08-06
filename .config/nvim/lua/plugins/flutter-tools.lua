return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap",
  },

  config = function()
    local dap = require("dap")

    local flutter_path = vim.fn.exepath("flutter")

    if flutter_path == "" then
      vim.notify("Flutter executable not found. Check mise activation and PATH.", vim.log.levels.ERROR)
      return
    end

    -- /path/to/flutter/bin/flutter -> /path/to/flutter
    local flutter_sdk = vim.fs.dirname(vim.fs.dirname(flutter_path))
    local dart_sdk = flutter_sdk .. "/bin/cache/dart-sdk"

    require("flutter-tools").setup({
      fvm = false,

      -- This may also be omitted because flutter-tools can find
      -- `flutter` automatically from PATH.
      flutter_path = flutter_path,

      debugger = {
        enabled = true,
      },

      dev_log = {
        enabled = false,
      },
    })

    dap.adapters.dart = {
      type = "executable",
      command = flutter_path,
      args = { "debug_adapter" },
    }

    dap.configurations.dart = {
      {
        name = "Flutter Chrome",
        type = "dart",
        request = "launch",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",

        flutterSdkPath = flutter_sdk,
        dartSdkPath = dart_sdk,

        toolArgs = {
          "-d",
          "chrome",
        },
      },
    }

    vim.keymap.set("n", "<leader>dc", function()
      dap.run(dap.configurations.dart[1])
    end, {
      desc = "Debug Flutter Chrome",
    })
  end,
}
