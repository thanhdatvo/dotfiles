return {
  "emrearmagan/dockyard.nvim",
  dependencies = {
    "akinsho/toggleterm.nvim", -- optional
  },
  cmd = { "Dockyard", "DockyardFloat" },
  lazy = true,
  config = function()
    require("dockyard").setup({})
  end,
}
