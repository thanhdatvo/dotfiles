return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true, -- Lazy load Neo-tree
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
    opts.default_component_configs.file_size = {
      enabled = false,
    }
    opts.default_component_configs.last_modified = {
      enabled = false,
    }
    opts.default_component_configs.type = {
      enabled = false,
    }
    -- opts.default_component_configs.type.enabled = false
    -- opts.default_component_configs.last_modified.enabled = false
    opts.default_component_configs.indent.indent_size = 2
    -- opts.filesystem.filtered_items = {
    --   -- hide_hidden = false,
    --   visible = true,
    -- }
    -- opts.default_component_configs = {
    --   file_size = {
    --     enabled = false,
    --   },
    --   last_modified = {
    --     enabled = false,
    --   },
    --   type = {
    --     enabled = false,
    --   },
    --   -- indent = {
    --   --   indent_size = 1,
    --   -- },
    -- }
  end,
}
