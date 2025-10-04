return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended
  lazy = false, -- This plugin is already lazy

  config = function()
    -- Note: disable rust-analyzer to use bacon-ls
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = false,
            dianostics = { enable = false },
          },
        },
      },
    }

    local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.11.5/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb"
    local this_os = vim.uv.os_uname().sysname

    -- The path is different on Windows
    if this_os:find("Windows") then
      codelldb_path = extension_path .. "adapter\\codelldb.exe"
      liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
    else
      -- The liblldb extension is .so for Linux and .dylib for MacOS
      liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end

    local cfg = require("rustaceanvim.config")
    local lldb_adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
    local program = function(callback, config)
      vim.fn.jobstart("cargo build", {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= "" then
                vim.schedule(function()
                  vim.notify("[cargo] " .. line)
                end)
              end
            end
          end
        end,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.notify("✅ Build succeeded", vim.log.levels.INFO)

              callback(lldb_adapter) -- continue to start the debug adapter
            else
              vim.notify("❌ Build failed. Debug cancelled.", vim.log.levels.ERROR)
            end
          end)
        end,
      })
    end

    local dap = require("dap")
    dap.adapters.lldb = program
  end,
}
