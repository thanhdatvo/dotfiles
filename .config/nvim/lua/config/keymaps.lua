-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

local dap = require("dap")
function RestartDAPSession()
  if dap.session() then
    local function run_after_terminate()
      -- remove listener after use
      dap.listeners.after.event_terminated["restart_dap"] = nil
      dap.listeners.after.event_exited["restart_dap"] = nil

      -- now we can run the last session
      dap.run_last()
    end

    -- hook into the termination events
    dap.listeners.after.event_terminated["restart_dap"] = run_after_terminate
    dap.listeners.after.event_exited["restart_dap"] = run_after_terminate

    -- trigger termination
    -- dap.terminate()
    dap.disconnect({ terminate = true })
  else
    -- no session running, just run the last config
    dap.run_last()
  end
end

vim.keymap.set("n", "<leader>dr", RestartDAPSession, { desc = "DAP: Restart session" })

vim.keymap.set("n", "<leader>yd", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags > 0 then
    local msg = diags[1].message
    -- vim.fn.setreg('"', msg)
    vim.fn.setreg("+", msg)
    print("Yanked diagnostic: " .. msg)
  else
    print("No diagnostic here")
  end
end, { desc = "desc  desc  message" })

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking replaced text" })

-- expand rust macro under cursor
-- open a pop up window
vim.keymap.set("n", "<leader>re", function()
  local before = vim.api.nvim_list_wins()

  vim.cmd.RustLsp("expandMacro")

  vim.defer_fn(function()
    local after = vim.api.nvim_list_wins()
    local new_win = nil

    for _, win in ipairs(after) do
      local found = false
      for _, old in ipairs(before) do
        if win == old then
          found = true
          break
        end
      end

      if not found then
        new_win = win
        break
      end
    end

    if not new_win or not vim.api.nvim_win_is_valid(new_win) then
      vim.notify("Could not find macro expansion window", vim.log.levels.WARN)
      return
    end

    local buf = vim.api.nvim_win_get_buf(new_win)
    vim.api.nvim_win_close(new_win, true)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.75)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local float_win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      title = " Macro Expansion ",
      title_pos = "center",
    })

    vim.bo[buf].filetype = "rust"
    vim.wo[float_win].wrap = false
    vim.wo[float_win].number = false
    vim.wo[float_win].relativenumber = false

    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
      end
    end, { buffer = buf, silent = true })
  end, 100)
end, { desc = "Rust expand macro in popup" })

-- [START] DAP UI

local dap_terminal = {
  buf = nil,
  win = nil,
}

local function open_dap_terminal_float()
  if dap_terminal.buf and vim.api.nvim_buf_is_valid(dap_terminal.buf) then
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    dap_terminal.win = vim.api.nvim_open_win(dap_terminal.buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      style = "minimal",
      border = "rounded",
      title = " Application ",
      title_pos = "center",
    })

    vim.cmd("startinsert")
    return
  end

  vim.notify("DAP application terminal has not been created yet")
end

local dap = require("dap")

dap.defaults.fallback.force_external_terminal = false
dap.defaults.fallback.terminal_win_cmd = "belowright new"

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)

    -- You may need to adjust this condition for your adapter.
    if bufname:match("dap") then
      dap_terminal.buf = args.buf
    end
  end,
})

vim.keymap.set({ "n", "t" }, "<leader>at", function()
  if vim.api.nvim_get_mode().mode:sub(1, 1) == "t" then
    vim.cmd([[stopinsert]])
  end

  if dap_terminal.win and vim.api.nvim_win_is_valid(dap_terminal.win) then
    vim.api.nvim_win_close(dap_terminal.win, false)
    dap_terminal.win = nil
  else
    open_dap_terminal_float()
  end
end, {
  desc = "Toggle DAP application terminal",
  silent = true,
})

-- [END] DAP UI
