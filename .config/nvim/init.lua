-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("custom.case_replace_command")
require("custom.run_flutter_command")

vim.filetype.add({
  extension = {

    svx = "svelte",
  },
})
