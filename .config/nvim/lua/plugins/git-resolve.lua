return {
  "spacedentist/resolve.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- opts = {},
  config = function()
    require("resolve").setup({})

    vim.api.nvim_set_hl(0, "ResolveOursMarker", { bg = "#2f7366", bold = true })
    vim.api.nvim_set_hl(0, "ResolveOursSection", { bg = "#2e5049" })
    vim.api.nvim_set_hl(0, "ResolveSeparatorMarker", { bg = "#4a4a4a", bold = true })
    vim.api.nvim_set_hl(0, "ResolveTheirsSection", { bg = "#344f69" })
    vim.api.nvim_set_hl(0, "ResolveTheirsMarker", { bg = "#2f628e", bold = true })

    vim.api.nvim_set_hl(0, "ResolveAncestorMarker", { bg = "#5c4d3d", bold = true })
    vim.api.nvim_set_hl(0, "ResolveAncestorSection", { bg = "#3a322a" })
  end,
}
