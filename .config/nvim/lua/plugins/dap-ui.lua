return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  enabled = true,
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
          -- "console", -- or use 'terminal' below
        },
        size = 0.25,
        position = "bottom",
      },
    }, -- layouts = {
  },
}
