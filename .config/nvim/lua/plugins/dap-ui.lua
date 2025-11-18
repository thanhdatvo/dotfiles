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
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup(opts)
    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- print("before event terminated")
      -- keep dap UI open when the debugger is stopped
      dapui.open({})
    end
  end,
}
