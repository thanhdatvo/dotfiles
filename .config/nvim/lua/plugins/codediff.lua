return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",

  keys = {
    { "<leader>gg", "<cmd>CodeDiff<cr>", desc = "Show CodeDiff UI" },
    {
      "<leader>gd",
      "<cmd>CodeDiff file HEAD<cr>",
      desc = "Diff Current File",
    },
  },
  opts = {
    explorer = {
      view_mode = "tree",
      width = 20,
    },
  },
}
