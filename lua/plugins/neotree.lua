return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.window.mappings = {
      ["<Tab>"] = "toggle_node", -- Use Tab to expand/collapse folder
    }
    opts.event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(arg)
          vim.opt.relativenumber = true
        end,
      },
    }
  end,
}
