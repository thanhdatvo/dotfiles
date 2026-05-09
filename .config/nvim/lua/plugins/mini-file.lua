return {
  {
    "nvim-mini/mini.files",
    version = false,
    keys = {
      { "<leader>fm", false },
      {
        "<leader><space>",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 90,
      },
    },
  },
}
