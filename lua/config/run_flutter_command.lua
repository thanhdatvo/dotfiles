local function press_enter()
  print("press_enter")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end
local function wait_for_ui_and_select(option_key, callback)
  local function execute()
    print("select" .. option_key)
    vim.api.nvim_feedkeys(option_key, "n", false)
    press_enter()
    -- press_enter()
    if callback then
      callback()
    end
  end
  -- Define a function to check for the UI
  local function check_and_select()
    -- Example: Check if a buffer, floating window, or quickfix list is open
    local is_ui_open = vim.fn.mode() == "t" -- Adjust this based on your UI's mode

    if is_ui_open then
      vim.defer_fn(execute, 100)
    else
      vim.defer_fn(check_and_select, 100) -- Check again in 100ms
    end
  end

  -- Start polling for the UI
  check_and_select()
end

vim.api.nvim_create_user_command("RunFlutter", function(opts)
  vim.cmd("FlutterDevices")
  wait_for_ui_and_select("1", function()
    print("continue")
    wait_for_ui_and_select("2")
  end)
end, { nargs = "*" })
