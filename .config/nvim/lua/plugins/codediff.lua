return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",

  keys = {
    { "<leader>gg", "<cmd>CodeDiff<cr>", desc = "Show CodeDiff UI" },
  },
  opts = {
    explorer = {
      view_mode = "tree",
    },
  },
}
