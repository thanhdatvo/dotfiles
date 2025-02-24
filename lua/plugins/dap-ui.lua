return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  opts = {
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.66 },
          { id = "breakpoints", size = 0.34 },
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          { id = "repl", size = 1 },
        },
        size = 10,
        position = "bottom",
      },
    },
  },
  -- config = function(_, opts)
  --   local dap = require("dap")
  --   local dapui = require("dapui")
  --   dapui.setup(opts)
  --   dap.listeners.after.event_initialized["dapui_config"] = function()
  --     dapui.open({})
  --   end
  --   dap.listeners.before.event_terminated["dapui_config"] = function()
  --     dapui.close({})
  --   end
  --   dap.listeners.before.event_exited["dapui_config"] = function()
  --     dapui.close({})
  --   end
  -- end,
}
