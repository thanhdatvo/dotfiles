return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },
  keys = {
    {
      "<leader>gh",
      function()
        local view = require("diffview.lib").get_current_view()

        if view then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewFileHistory %")
        end
      end,
      desc = "Toggle Current File History",
    },
  },
}
