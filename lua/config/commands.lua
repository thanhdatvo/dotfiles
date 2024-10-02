vim.api.nvim_create_user_command("Upper", function(opts)
  print(string.upper(opts.fargs[1]))
end, { nargs = "*" })
-- xyX
-- XyX
-- xy_x
-- -- Define a function to handle case-sensitive replacements
local function upper_first_letter(text)
  return text:sub(1, 1):upper() .. text:sub(2)
end

function CaseReplace(old_word, new_word)
  -- Escape the words for pattern matching
  local escaped_old = vim.fn.escape(old_word, "\\")
  local escaped_new = vim.fn.escape(new_word, "\\")

  vim.api.nvim_out_write("old_word: " .. escaped_old .. "\n")
  -- Patterns to match different cases
  local patterns = {
    -- camelCase (e.g., helloWorld -> hiWorld)
    { pattern = "\\C\\<" .. escaped_old .. "\\>", replace = new_word },

    -- PascalCase (e.g., HelloWorld -> HiWorld)
    { pattern = "\\C\\<" .. upper_first_letter(escaped_old) .. "\\>", replace = "\\u" .. escaped_new },

    -- snake_case (e.g., hello_world -> hi_world)
    {
      pattern = "\\C\\<" .. old_word:gsub("(%u)", "_%1"):lower() .. "\\>",
      replace = new_word:gsub("(%u)", "_%1"):lower(),
    },
  }
  --
  -- -- Apply each pattern
  for _, pat in ipairs(patterns) do
    local success, result = pcall(vim.cmd, ":%s/" .. pat.pattern .. "/" .. pat.replace .. "/g")
    -- vim.cmd(":%s/" .. pat.pattern .. "/" .. pat.replace .. "/g")
    if not success then
      -- vim.api.nvim_err_writeln("Error replacing " .. pat.pattern .. " with " .. pat.replace)
    else
      vim.api.nvim_out_write("Replaced " .. pat.pattern .. " with " .. pat.replace .. "\n")
    end
    -- vim.api.nvim_out_write("pattern: " .. pat.pattern .. " ,replace: " .. pat.replace .. "\n")
  end
end

-- Create a custom command in Neovim that takes two arguments: the old and new words
vim.api.nvim_create_user_command("CaseReplace", function(opts)
  CaseReplace(opts.args:match("(%S+)"), opts.args:match("%S+$"))
end, { nargs = "*" })
