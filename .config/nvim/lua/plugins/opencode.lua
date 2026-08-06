return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",

    enabled = false,
    config = function()
      vim.g.opencode_opts = {}

      -- Ask about the visual selection or cursor position.
      vim.keymap.set({ "n", "x" }, "<leader>oa", function()
        require("opencode").ask("@this: ")
      end, {
        desc = "Ask OpenCode about selection",
      })

      -- Choose predefined actions such as Explain, Review, or Optimize.
      vim.keymap.set({ "n", "x" }, "<leader>oo", function()
        require("opencode").select()
      end, {
        desc = "OpenCode actions",
      })
    end,
  },
}
