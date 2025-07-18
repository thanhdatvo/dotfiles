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
    dap.terminate()
  else
    -- no session running, just run the last config
    dap.run_last()
  end
end
vim.keymap.set("n", "<leader>dr", RestartDAPSession, { desc = "DAP: Restart session" })
