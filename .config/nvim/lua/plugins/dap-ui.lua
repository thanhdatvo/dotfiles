return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  opts = {
    layouts = {
      {
        elements = {
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl", -- debugging console
          "console", -- or use 'terminal' below
        },
        size = 0.25,
        position = "bottom",
      },
    }, -- layouts = {
    --   {
    --     elements = {
    --       { id = "scopes", size = 0.66 },
    --       { id = "breakpoints", size = 0.34 },
    --     },
    --     size = 40,
    --     position = "left",
    --   },
    --   {
    --     elements = {
    --       { id = "repl", size = 1 },
    --     },
    --     size = 10,
    --     position = "bottom",
    --   },
    -- },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data ~= "nvim-dap-ui" then
          return
        end

        local dap = require("dap")
        local dapui = require("dapui")

        -- Disable LazyVim / dap-ui default auto-close behavior
        dap.listeners.before.event_terminated["dapui_config"] = nil
        dap.listeners.before.event_exited["dapui_config"] = nil

        -- Optional: force it to stay open after debugger stops
        dap.listeners.after.event_terminated["keep_dapui_open"] = function()
          vim.schedule(function()
            dapui.open({})
          end)
        end

        dap.listeners.after.event_exited["keep_dapui_open"] = function()
          vim.schedule(function()
            dapui.open({})
          end)
        end
      end,
    })
  end,
}
