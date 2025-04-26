return {
  "mfussenegger/nvim-dap",
  optional = true,
  opts = function()
    local dap = require("dap")
    local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()

    dap.adapters.go = {
      type = "server",
      port = 38697,
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:38697" },
      },
      enrich_config = function(finalConfig, on_config)
        local final_config = vim.deepcopy(finalConfig)
        -- final_config.console = "integratedTerminal"
        final_config.console = "integratedConsole"
        final_config.output = "debug" -- you can nam
        final_config.showLog = true
        -- Placeholder expansion for launch directives
        local placeholders = {
          ["${file}"] = function(_)
            return vim.fn.expand("%:p")
          end,
          ["${fileBasename}"] = function(_)
            return vim.fn.expand("%:t")
          end,
          ["${fileBasenameNoExtension}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
          end,
          ["${fileDirname}"] = function(_)
            return vim.fn.expand("%:p:h")
          end,
          ["${fileExtname}"] = function(_)
            return vim.fn.expand("%:e")
          end,
          ["${relativeFile}"] = function(_)
            return vim.fn.expand("%:.")
          end,
          ["${relativeFileDirname}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
          end,
          ["${workspaceFolder}"] = function(_)
            return vim.fn.getcwd()
          end,
          ["${workspaceFolderBasename}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          ["${env:([%w_]+)}"] = function(match)
            return os.getenv(match) or ""
          end,
        }

        if final_config.envFile then
          local filePath = final_config.envFile
          for key, fn in pairs(placeholders) do
            filePath = filePath:gsub(key, fn)
          end

          for line in io.lines(filePath) do
            if #line == 0 or line[1] == "#" then
            else
              local words = {}
              for word in string.gmatch(line, "[^=]+") do
                table.insert(words, word)
              end
              if words[2] ~= nil and words[2] ~= "" then
                if not final_config.env then
                  final_config.env = {}
                end
                if not final_config.env[words[1]] then
                  final_config.env[words[1]] = words[2]:match('^"?(.-)"?$') -- remove leading/trailing quotes
                end
              end
            end
          end
        end

        on_config(final_config)
      end,
    }
    dap.adapters.lldb = {
      type = "executable",
      command = "codelldb", -- Path to `codelldb` binary
      name = "lldb",
    }

    dap.configurations.rust = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        preLaunchTask = function()
          -- Run cargo build before starting the debugger
          local result = vim.fn.system("cargo build")
          if vim.v.shell_error ~= 0 then
            print("❌ Cargo build failed!")
            print(result)
            return false
          end
          -- print("✅ Cargo build succeeded!")
          return true
        end,
        program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
        -- program = function()
        --   return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        -- end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }
    -- dap.adapters.lldb = {
    --   type = "executable",
    --   -- command = "/usr/bin/lldb", -- adjust as needed, must be absolute path
    --   command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
    --   name = "lldb",
    -- }
    --
    dap.configurations.zig = {
      {
        name = "Debug Zig",
        type = "lldb",
        request = "launch",
        program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
        preLaunchTask = function()
          -- Run cargo build before starting the debugger
          local result = vim.fn.system("zig build")
          if vim.v.shell_error ~= 0 then
            print("❌ zig build failed!")
            print(result)
            return false
          end
          -- print("✅ Cargo build succeeded!")
          return true
        end,
        -- program = function()
        --   return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
        -- end,
        -- program = function()
        --   return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "try-simple-http-backend")
        -- end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }
  end,
}
