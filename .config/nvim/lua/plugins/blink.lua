return {
  {
    "saghen/blink.cmp",

    opts = {
      completion = {
        menu = {
          border = "rounded",

          -- Keep the completion menu relatively narrow.
          min_width = 15,
          max_height = 10,

          draw = {
            align_to = "label",

            columns = {
              { "label", gap = 1 },
              { "kind", gap = 1 },
            },

            components = {
              label = {
                width = {
                  max = 30,
                },
              },

              label_description = {
                width = {
                  max = 20,
                },
              },
            },
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,

          window = {
            border = "rounded",

            -- Important: smaller docs make west placement possible.
            min_width = 50,
            max_width = 40,
            max_height = 15,

            direction_priority = {
              menu_north = { "w", "e" },
              menu_south = { "w", "e" },
            },
          },
        },
      },
    },

    init = function()
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", {
        fg = "#89b4fa",
      })

      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", {
        fg = "#89b4fa",
      })
    end,
  },
}
