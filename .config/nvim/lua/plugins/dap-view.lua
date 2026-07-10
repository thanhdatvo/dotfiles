return {

  "thanhdatvo/nvim-dap-view",
  branch = "feature/preserve-cursor-on-tab-switch",
  -- "igorlfs/nvim-dap-view",

  -- name = "nvim-dap-view",
  -- dir = "~/Work/lua-projects/nvim-dap-view",
  dependencies = {
    "mfussenegger/nvim-dap",
  },

  -- enabled = false,
  opts = {
    debug_mode = true,
    winbar = {
      sections = { "console", "repl", "breakpoints", "scopes" },
      default_section = "console",
      show_keymap_hints = false,
    },
    keymaps = {
      base = {
        next_view = "L",
        prev_view = "H",
      },
    },
  },
  keys = {
    {
      "<leader>du",
      "<cmd>DapViewToggle<cr>",
      desc = "Toggle DAP View",
    },
  },
  config = function(_, opts)
    -- require("dap-view").setup(opts)
    local dapview = require("dap-view")
    dapview.setup(opts)

    vim.api.nvim_set_hl(0, "NvimDapViewTabSelected", {
      fg = "#e6e9f5",
      bg = "NONE",
      bold = true,
    })

    vim.api.nvim_set_hl(0, "NvimDapViewTab", {
      fg = "#aab2d5", -- unselected tab text color
      bg = "NONE",
    })
    --- background transparent START

    vim.api.nvim_set_hl(0, "WinBarNC", {
      bg = "NONE",
      ctermbg = "NONE",
    })

    vim.api.nvim_set_hl(0, "WinBar", {
      bg = "NONE",
      ctermbg = "NONE",
    })
    --- background transparent START

    local function setup_dap_view_numbers_for_win(win)
      if not vim.api.nvim_win_is_valid(win) then
        return
      end

      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype

      if ft ~= "dap-view" and ft ~= "dap-view-term" and ft ~= "dap-repl" then
        return
      end

      vim.api.nvim_set_hl(0, "DapViewLineNr", {
        fg = "#666666",
        bg = "NONE",
      })

      vim.api.nvim_set_hl(0, "DapViewCursorLineNr", {
        fg = "#f5a97f",
        bg = "NONE",
        bold = true,
      })

      vim.api.nvim_set_option_value("number", true, { win = win })
      vim.api.nvim_set_option_value("relativenumber", true, { win = win })

      -- Make gutter fixed
      vim.api.nvim_set_option_value("numberwidth", 2, { win = win })
      vim.api.nvim_set_option_value("signcolumn", "yes", { win = win })
      vim.api.nvim_set_option_value("foldcolumn", "0", { win = win })

      -- Very important: override custom statuscolumn
      vim.api.nvim_set_option_value("statuscolumn", "%=%l ", { win = win })

      -- Optional: avoid visual wrap changing perceived indentation
      vim.api.nvim_set_option_value("wrap", false, { win = win })

      vim.api.nvim_set_option_value(
        "winhighlight",
        table.concat({
          "LineNr:DapViewLineNr",
          "CursorLineNr:DapViewCursorLineNr",
        }, ","),
        {
          win = win,
        }
      )
    end

    local function setup_all_dap_view_numbers()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        setup_dap_view_numbers_for_win(win)
      end
    end

    vim.api.nvim_create_autocmd({
      "FileType",
      "BufWinEnter",
      "WinEnter",
      "TermOpen",
    }, {
      pattern = {
        "dap-view",
        "dap-view-term",
        "dap-repl",
        "*",
      },
      callback = function()
        vim.schedule(setup_all_dap_view_numbers)
      end,
    })
  end,
}
