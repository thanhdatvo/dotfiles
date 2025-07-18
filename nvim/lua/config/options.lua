-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- helloCase helloCaseMe hello_case
-- Enable true color support
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Tmux clipboard integration
vim.opt.clipboard = "unnamedplus"

vim.g.nightflyWinSeparator = 2
