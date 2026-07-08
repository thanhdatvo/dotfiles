return {
  "jellydn/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Optional, for markdown rendering with render-markdown.nvim
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown" },
      },
      ft = { "markdown" },
    },
  },
  -- init = function()
  --   vim.filetype.add({
  --     extension = {
  --       hurl = "hurl",
  --     },
  --   })
  -- end,
  ft = "hurl",
  opts = {},
  keys = {},
}
