return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    opts.highlights = opts.highlights or {}

    local function set_bg(name)
      opts.highlights[name] = vim.tbl_extend("force", opts.highlights[name] or {}, {
        bg = "NONE",
      })
    end

    set_bg("fill")
    set_bg("background")

    set_bg("separator")
    set_bg("separator_visible")
    set_bg("separator_selected")

    set_bg("close_button")
    set_bg("close_button_visible")
    set_bg("close_button_selected")

    set_bg("buffer_selected")
  end,
}
