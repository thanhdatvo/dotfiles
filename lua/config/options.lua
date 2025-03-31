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

vim.api.nvim_create_augroup("ModeBackground", { clear = true })

-- Set Normal mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:n",
  command = "highlight Normal guibg=#1e1e1e",
})

-- Set Insert mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:i",
  command = "highlight Normal guibg=#005f5f",
})

-- Set Visual mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:v",
  command = "highlight Normal guibg=#5f0000",
})

-- Set Command mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:c",
  command = "highlight Normal guibg=#5f5f00",
})
