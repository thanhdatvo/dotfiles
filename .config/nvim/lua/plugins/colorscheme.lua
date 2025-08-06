-- return {
--   "baliestri/aura-theme",
--   lazy = false,
--   priority = 1000,
--   config = function(plugin)
--     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
--     vim.cmd([[colorscheme aura-dark]])
--   end,
-- }
return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    vim.cmd("colorscheme rose-pine")
  end,
}
-- return {
--   -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
--   -- {
--   --   "LazyVim/LazyVim",
--   --   opts = {
--   --     colorscheme = "catppuccin-mocha",
--   --   },
--   -- },
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
