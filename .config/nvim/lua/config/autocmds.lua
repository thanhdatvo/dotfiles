-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.cmd([[
--   " set background for float window
--   highlight NormalFloat guibg=NONE
--   " set background for line number on left
--   hi LineNr ctermbg=none guibg=none
--
--   " disable Normal background on start
--   highlight Normal guibg=NONE
--
--   " disable Terminal background
--   highlight TermCursor guibg=NONE
-- ]])

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

-- remove this in the future when
-- filetype detect order work
vim.schedule(function()
  vim.cmd("filetype detect")
end)

local function set_transparent_ui_highlights()
  -- core backgrounds
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TermCursor", { bg = "NONE" })

  -- tabline
  vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

  -- line numbers
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#666666", bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#666666", bg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f5a97f", bg = "NONE", bold = true })

  -- vertical separators
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#8aa0c8", bg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = "#8aa0c8", bg = "NONE" })

  -- bufferline text
  vim.api.nvim_set_hl(0, "BufferLineBackground", { fg = "#8b93b5", bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineBufferVisible", { fg = "#aab2d5", bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = "#e6e9f5", bg = "NONE", bold = true })

  -- bufferline separators
  vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#5f6b8a", bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = "#5f6b8a", bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "#7a88ad", bg = "NONE" })
end

-- ============================================================================
-- Apply highlights on startup and after colorscheme changes
-- ============================================================================

local ui_group = vim.api.nvim_create_augroup("CustomUIHighlights", { clear = true })
-- run immediately
set_transparent_ui_highlights()

-- run again if you later change colorscheme manually
vim.api.nvim_create_autocmd("ColorScheme", {
  group = ui_group,
  callback = set_transparent_ui_highlights,
})
