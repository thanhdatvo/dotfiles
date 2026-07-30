return {
  "nvim-mini/mini.comment",
  opts = {
    options = {
      custom_commentstring = function()
        -- local ft = vim.bo.filetype
        -- if ft == "ripple" then
        --   return "<!-- %s -->"
        -- end
        local ft = vim.bo.filetype

        if ft == "tsrx" or ft == "ripple" then
          return "// %s"
        end

        if ft == "terraform-vars" then
          return "# %s"
        end
        return vim.bo.commentstring
      end,
    },
  },
}
