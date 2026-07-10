return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "nvim-neotest/nvim-nio" },
  enabled = false,
  opts = {
    layouts = {
      {
        elements = {
          "scopes",
          "breakpoints",
          "stacks",
          "watches",
        },
        size = 40,
        position = "left",
      },
      {
        elements = {
          "repl", -- debugging console
          "console", -- or use 'terminal' below
        },
        size = 0.25,
        position = "bottom",
      },
    }, -- layouts = {
    --   {
    --     elements = {
    --       { id = "scopes", size = 0.66 },
    --       { id = "breakpoints", size = 0.34 },
    --     },
    --     size = 40,
    --     position = "left",
    --   },
    --   {
    --     elements = {
    --       { id = "repl", size = 1 },
    --     },
    --     size = 10,
    --     position = "bottom",
    --   },
    -- },
  },
  -- config = function(_, opts)
  --   local dap = require("dap")
  --   local dapui = require("dapui")
  --
  --   dapui.setup(opts)
  --
  --   dap.listeners.before.attach["dapui_config"] = function()
  --     dapui.open()
  --   end
  --
  --   dap.listeners.before.launch["dapui_config"] = function()
  --     dapui.open()
  --   end
  --
  --   -- Do not define these:
  --   -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   --   dapui.close()
  --   -- end
  --   --
  --   -- dap.listeners.before.event_exited["dapui_config"] = function()
  --   --   dapui.close()
  --   -- end
  -- end,
  init = function()
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "LazyLoad",
    --   callback = function(event)
    --     if event.data ~= "nvim-dap-ui" then
    --       return
    --     end
    --
    --     local dap = require("dap")
    --     local dapui = require("dapui")
    --
    --     -- Disable LazyVim / dap-ui default auto-close behavior
    --     dap.listeners.before.event_terminated["dapui_config"] = nil
    --     dap.listeners.before.event_exited["dapui_config"] = nil
    --
    --     -- Optional: force it to stay open after debugger stops
    --     dap.listeners.after.event_terminated["keep_dapui_open"] = function()
    --       vim.schedule(function()
    --         dapui.open({})
    --       end)
    --     end
    --
    --     dap.listeners.after.event_exited["keep_dapui_open"] = function()
    --       vim.schedule(function()
    --         dapui.open({})
    --       end)
    --     end
    --   end,
    -- })

    --   local dap = require("dap")
    --   local dapui = require("dapui")
    --
    --   dapui.setup(opts)
    --
    --   local function disable_dapui_winfixbuf()
    --     vim.schedule(function()
    --       for _, win in ipairs(vim.api.nvim_list_wins()) do
    --         local buf = vim.api.nvim_win_get_buf(win)
    --         local name = vim.api.nvim_buf_get_name(buf)
    --
    --         if name:match("^dap%-ui://") then
    --           pcall(vim.api.nvim_set_option_value, "winfixbuf", false, { win = win })
    --         end
    --       end
    --     end)
    --   end
    --
    --   local function scroll_dapui_console_to_bottom()
    --     vim.schedule(function()
    --       for _, win in ipairs(vim.api.nvim_list_wins()) do
    --         local buf = vim.api.nvim_win_get_buf(win)
    --         local name = vim.api.nvim_buf_get_name(buf)
    --
    --         if name:match("^dap%-ui://console") or name:match("^dap%-ui://repl") then
    --           local line_count = vim.api.nvim_buf_line_count(buf)
    --           pcall(vim.api.nvim_win_set_cursor, win, { line_count, 0 })
    --         end
    --       end
    --     end)
    --   end
    --
    --   dap.listeners.after.event_initialized["dapui_open"] = function()
    --     dapui.open()
    --     disable_dapui_winfixbuf()
    --   end
    --
    --   dap.listeners.after.event_stopped["disable_dapui_winfixbuf"] = disable_dapui_winfixbuf
    --   dap.listeners.after.event_output["scroll_dapui_console"] = scroll_dapui_console_to_bottom
    --   dap.listeners.after.event_stopped["scroll_dapui_console"] = scroll_dapui_console_to_bottom
    --
    --   vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "FileType" }, {
    --     callback = disable_dapui_winfixbuf,
    --   })
    --
    --   local function scroll_dap_console_to_bottom()
    --     vim.schedule(function()
    --       local win = vim.api.nvim_get_current_win()
    --       local buf = vim.api.nvim_win_get_buf(win)
    --       local name = vim.api.nvim_buf_get_name(buf)
    --
    --       if name:match("^dap%-ui://console") or name:match("^dap%-ui://repl") then
    --         local line_count = vim.api.nvim_buf_line_count(buf)
    --         pcall(vim.api.nvim_win_set_cursor, win, { line_count, 0 })
    --       end
    --     end)
    --   end
    --   vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    --     callback = scroll_dap_console_to_bottom,
    --   })
  end,
}
