return {
  "iamcco/markdown-preview.nvim",
  cmd = {
    "MarkdownPreview",
    "MarkdownPreviewStop",
    "MarkdownPreviewToggle",
  },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }

    -- Auto open preview when entering markdown file
    -- 0 = disabled, 1 = enabled
    vim.g.mkdp_auto_start = 0

    -- Auto close preview when leaving markdown buffer
    vim.g.mkdp_auto_close = 1

    -- Refresh preview when buffer changes
    vim.g.mkdp_refresh_slow = 0

    -- Open preview in browser
    vim.g.mkdp_browser = ""
  end,
}
