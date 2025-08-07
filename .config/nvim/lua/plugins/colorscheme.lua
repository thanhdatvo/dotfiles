-- return {
--   "baliestri/aura-theme",
--   lazy = false,
--   priority = 1000,
--   config = function(plugin)
--     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
--     vim.cmd([[colorscheme aura-dark]])
--   end,
-- }
-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   config = function()
--     require("rose-pine").setup({
--       styles = {
--         italic = false,
--       },
--     })
--     vim.cmd("colorscheme rose-pine")
--   end,
--   opts = {},
-- }
-- return {
--   { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin-mocha",
--     },
--   },
-- }
-- return {
--   {
--     "bluz71/vim-nightfly-colors",
--     name = "nightfly",
--     lazy = true,
--     priority = 1000,
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "nightfly",
--     },
--   },
-- }
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme tokyonight-day")
  end,
  -- opts = {
  --   colorscheme = "tokyonight-day",
  -- },
}
