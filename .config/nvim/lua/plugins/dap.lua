return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "stevearc/overseer.nvim",
    -- "rcarriga/nvim-dap-ui",
  },

  optional = true,
  opts = function()
    local dap = require("dap")
    -- local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()

    -- [START GOLANG]
    local function get_random_port()
      math.randomseed(os.time())
      return math.random(30000, 40000)
    end

    local enrich_go_config = function(finalConfig, on_config)
      local final_config = vim.deepcopy(finalConfig)
      -- final_config.console = "integratedTerminal"
      -- final_config.console = "internalConsole"
      -- final_config.output = "debug" -- you can nam
      -- final_config.showLog = true
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
    end
    dap.adapters.go = function(callback, config)
      function trimLeftRight(s)
        return s:match("^%s*(.-)%s*$")
      end
      local port = get_random_port()

      -- Launch delve server manually
      local handle
      local pid_or_err
      local stdout = vim.loop.new_pipe(false)
      local stderr = vim.loop.new_pipe(false)

      handle, pid_or_err = vim.loop.spawn("dlv", {
        args = { "dap", "-l", "127.0.0.1:" .. port },
        stdio = { nil, stdout, stderr },
        detached = true,
      }, function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
          vim.notify("dlv exited with code " .. code, vim.log.levels.ERROR)
        end
      end)
      local dap_repl = require("dap.repl")

      -- Wrap the default `append` function
      local original_append = dap_repl.append
      dap_repl.append = function(...)
        original_append(...)
        vim.defer_fn(function()
          -- Try to find and scroll the REPL buffer
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "dap-repl" then
              vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
            end
          end
        end, 10) -- delay a bit to ensure message is rendered
      end
      -- pipe stdout/stderr to REPL
      stdout:read_start(function(err, data)
        if data and string.len(trimLeftRight(data)) > 0 then
          data = trimLeftRight(data)
          vim.schedule(function()
            dap_repl.append(data)
          end)
        end
      end)
      -- Optionally read stderr
      stderr:read_start(function(err, data)
        if data and string.len(trimLeftRight(data)) > 0 then
          local red_err = "\27[31m" .. trimLeftRight(data) .. " \27[0m"
          vim.schedule(function()
            dap_repl.append(red_err)
          end)
        end
      end)

      -- Notify DAP to connect
      vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port, enrich_config = enrich_go_config })
      end, 100)
    end

    -- [END GOLANG]
    -- dap.adapters.lldb = {
    --   type = "executable",
    --   command = "codelldb", -- Path to `codelldb` binary
    --   name = "lldb",
    -- }

    dap.configurations.zig = {
      {
        name = "Debug Zig",
        type = "codelldb",
        request = "launch",
        program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
        preLaunchTask = function()
          -- Run cargo build before starting the debugger
          local result = vim.fn.system("zig build")
          if vim.v.shell_error ~= 0 then
            print("❌ zig build failed!" .. "\n" .. result)
            return false
          end
          print("✅ zig build succeeded!" .. vim.v.shell_error)
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

    -- Javascript [START]
    local js_debug_server = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

    if vim.fn.filereadable(js_debug_server) ~= 1 then
      vim.notify("js-debug-adapter not found. Run :MasonInstall js-debug-adapter", vim.log.levels.ERROR)
      return
    end

    for _, adapter in ipairs({
      "pwa-node",
      "pwa-chrome",
      "pwa-msedge",
    }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            js_debug_server,
            "${port}",
          },
        },
      }
    end

    require("overseer").enable_dap()

    -- Javascript [STOP]
  end,
}
