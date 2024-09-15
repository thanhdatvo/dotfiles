return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.window.mappings = {
      ["<Tab>"] = "toggle_node", -- Use Tab to expand/collapse folder
    }
  end,
}
