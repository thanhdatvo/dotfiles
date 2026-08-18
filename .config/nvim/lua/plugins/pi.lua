return {
  {
    "pablopunk/pi.nvim",

    keys = {
      {
        "<leader>ai",
        "<cmd>PiAsk<cr>",
        mode = "n",
        desc = "Ask pi",
      },
      {
        "<leader>ai",
        "<cmd>PiAskSelection<cr>",
        mode = "v",
        desc = "Ask pi (selection)",
      },
    },

    opts = {},
  },
}
