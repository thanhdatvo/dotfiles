return {
  {
    {
      "akinsho/toggleterm.nvim",
      config = true,
      cmd = "ToggleTerm",
      keys = {
        { "<F4>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      },
      opts = {
        open_mapping = [[<F4>]],
        direction = "float",
        shade_filetypes = {},
        insert_mappings = true,
        terminal_mappings = true,
        start_in_insert = true,
        close_on_exit = true,
        -- winbar = {
        --   enabled = false,
        --   name_formatter = function(term) --  term: Terminal
        --     return term.name
        --   end,
        -- },
      },
    },
  },
}
