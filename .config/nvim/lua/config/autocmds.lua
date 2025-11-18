-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.cmd([[highlight FloatBorder guibg=NONE]])
--
vim.cmd([[
  " set background for float window
  highlight NormalFloat guibg=NONE
  " set background for line number on left
  hi LineNr ctermbg=none guibg=none

  " disable Normal background on start
  highlight Normal guibg=NONE

  " disable Terminal background
  highlight TermCursor guibg=NONE
]])

vim.api.nvim_create_augroup("ModeBackground", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:n",
  command = "highlight Normal guibg=NONE",
})
-- Insert mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:i",
  command = "highlight Normal guibg=#005f5f",
})
-- Visual mode background
vim.api.nvim_create_autocmd("ModeChanged", {
  group = "ModeBackground",
  pattern = "*:v",
  command = "highlight Normal guibg=#351c46",
})
