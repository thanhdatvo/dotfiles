return {
  "folke/zen-mode.nvim",
  dependencies = {
    "folke/twilight.nvim", -- optional, for dimming inactive portions of the code
  },
  opts = {
    plugins = {
      twilight = { enabled = false }, -- enable twilight
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
