return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      focus_after_send = true,

      terminal = {
        split_width_percentage = 0.5,
        diff_split_width_percentage = 0.5,
        provider = "snacks",
        auto_insert = false,
      },
    },
  },
}
