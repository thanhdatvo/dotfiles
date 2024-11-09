return {
  "mfussenegger/nvim-dap",
  optional = true,
  opts = function()
    local dap = require("dap")
    local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
    dap.adapters.go = {
      type = "server",
      port = 38697,
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:38697" },
      },
      enrich_config = function(finalConfig, on_config)
        local final_config = vim.deepcopy(finalConfig)

        -- Placeholder expansion for launch directives
        local placeholders = {
          ["${file}"] = function(_)
            return vim.fn.expand("%:p")
          end,
          ["${fileBasename}"] = function(_)
            return vim.fn.expand("%:t")
          end,
          ["${fileBasenameNoExtension}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
          end,
          ["${fileDirname}"] = function(_)
            return vim.fn.expand("%:p:h")
          end,
          ["${fileExtname}"] = function(_)
            return vim.fn.expand("%:e")
          end,
          ["${relativeFile}"] = function(_)
            return vim.fn.expand("%:.")
          end,
          ["${relativeFileDirname}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
          end,
          ["${workspaceFolder}"] = function(_)
            return vim.fn.getcwd()
          end,
          ["${workspaceFolderBasename}"] = function(_)
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          ["${env:([%w_]+)}"] = function(match)
            return os.getenv(match) or ""
          end,
        }

        if final_config.envFile then
          local filePath = final_config.envFile
          for key, fn in pairs(placeholders) do
            filePath = filePath:gsub(key, fn)
          end

          for line in io.lines(filePath) do
            if #line == 0 or line[1] == "#" then
            else
              local words = {}
              for word in string.gmatch(line, "[^=]+") do
                table.insert(words, word)
              end
              if words[2] ~= nil and words[2] ~= "" then
                if not final_config.env then
                  final_config.env = {}
                end
                final_config.env[words[1]] = words[2]
              end
            end
          end
        end

        on_config(final_config)
      end,
    }
  end,
}
