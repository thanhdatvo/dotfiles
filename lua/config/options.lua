-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable true color support
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Tmux clipboard integration
vim.opt.clipboard = "unnamedplus"
