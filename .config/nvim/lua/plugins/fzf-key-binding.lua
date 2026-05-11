return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader><space>", false },
      { "<leader>,", false },
      --      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    },
    config = function()
      require("fzf-lua").setup({
        files = {
          fd_opts = "--type f --hidden --exclude .git --exclude build --exclude .dart_tool --exclude node_modules --exclude .build",
          git_icons = true,
          color_icons = true,
        },
        grep = {
          rg_opts = table.concat({
            "--hidden",
            "--column",
            "--line-number",
            "--no-heading",
            "--color=always",
            "--smart-case",
            "--max-filesize 50K",
            "--glob=!**/.dart_tool/*",
            "--glob=!**/.build/*",
            "--glob=!**/node_modules/*",
            "--glob=!**/assets/*",
            "--glob=!**/fonts/*",
          }, " "),
        },
      })
    end,
  },
}
