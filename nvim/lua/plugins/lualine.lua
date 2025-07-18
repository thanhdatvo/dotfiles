local colors = {
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = {
    -- options = {
    --   component_separators = { left = "", right = "" },
    --   section_separators = { left = "", right = "" },
    -- },
    options = {
      theme = bubbles_theme,
      component_separators = "",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      -- lualine_c = {
      --   "%=",
      --   {
      --     "mode",
      --     separator = { left = "", right = "" },
      --     color = function()
      --       local mode = vim.fn.mode()
      --       if mode == "n" then -- Normal mode
      --         return { fg = "#ffffff", bg = "#005f87", gui = "bold" }
      --       elseif mode == "i" then -- Insert mode
      --         return { fg = "#000000", bg = "#00ff87", gui = "bold" }
      --       elseif mode == "v" or mode == "V" or mode == "" then -- Visual
      --         return { fg = "#ffffff", bg = "#8700af", gui = "bold" }
      --       else
      --         return { fg = "#ffffff", bg = "#5f5f5f" }
      --       end
      --     end,
      --   },
      -- },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        { separator = { right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
    tabline = {},
    extensions = {},
  },
}
