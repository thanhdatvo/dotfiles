return {
  "joryeugene/dadbod-grip.nvim",
  version = "*", -- always latest stable; remove to track HEAD
  opts = {
    keymaps = {
      qpad_execute = "<leader>de",
      qpad_save = false,
    },
  },
  keys = {
    {
      "<leader>dq",
      function()
        vim.cmd("GripConnect")
        vim.defer_fn(function()
          vim.cmd("GripSchema")
        end, 1000)
      end,
      desc = "Grip connect + schema",
    },
  },
}
