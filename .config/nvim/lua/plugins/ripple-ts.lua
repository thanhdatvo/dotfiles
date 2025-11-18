return {
  "Ripple-TS/ripple",
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/packages/nvim-plugin")
    require("ripple").setup(plugin)
  end,
}
