return {
  "nvim-mini/mini.comment",
  opts = {
    options = {
      custom_commentstring = function()
        -- local ft = vim.bo.filetype
        -- if ft == "ripple" then
        --   return "<!-- %s -->"
        -- end
      end,
    },
  },
}
