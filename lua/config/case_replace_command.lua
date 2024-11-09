-- vim.api.nvim_create_user_command("Upper", function(opts)
--   print(string.upper(opts.fargs[1]))
-- end, { nargs = "*" })

function camelToPascal(str)
  -- Capitalize the first letter and concatenate with the rest of the string
  return str:gsub("^%l", string.upper)
end
function camelToSnake(str)
  -- Insert an underscore before each uppercase letter and convert to lowercase
  local snake = str:gsub("(%u)", "_%1"):lower()
  -- Remove any leading underscore (if the string started with an uppercase letter)
  return snake:gsub("^_", "")
end

function CaseReplace(old_word, new_word)
  -- Escape the words for pattern matching
  local escaped_old = vim.fn.escape(old_word, "\\")
  local escaped_new = vim.fn.escape(new_word, "\\")
  -- vim.api.nvim_out_write("camelCase: " .. escaped_old .. " " .. escaped_new .. "\n")

  local pascalOld = camelToPascal(escaped_old)
  local pascalNew = camelToPascal(escaped_new)
  -- vim.api.nvim_out_write("pascalCase: " .. pascalOld .. " " .. pascalNew .. "\n")

  local snakeOld = camelToSnake(escaped_old)
  local snakeNew = camelToSnake(escaped_new)
  -- vim.api.nvim_out_write("snakeCase: " .. snakeOld .. " " .. snakeNew .. "\n")

  local patterns = {
    { pattern = escaped_old, replace = escaped_new },
    { pattern = pascalOld, replace = pascalNew },
    { pattern = snakeOld, replace = snakeNew },
  }

  for _, pat in ipairs(patterns) do
    local success, result = pcall(vim.cmd, ":%s/" .. pat.pattern .. "/" .. pat.replace .. "/g")
    if success then
      vim.api.nvim_out_write("Replaced " .. pat.pattern .. " with " .. pat.replace .. "\n")
    else
    end
  end
end

-- Create a custom command in Neovim that takes two arguments: the old and new words
vim.api.nvim_create_user_command("CaseReplace", function(opts)
  CaseReplace(opts.args:match("(%S+)"), opts.args:match("%S+$"))
end, { nargs = "*" })
