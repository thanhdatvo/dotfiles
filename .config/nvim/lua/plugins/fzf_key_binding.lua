return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    },
    -- fzf_opts = {
    --   ["--no-scrollbar"] = true,
    -- },
    -- files = {
    --   find_opts = [[-type f]],
    --   -- find_opts = [[-name 'go.sum']],
    --   -- rg_opts = [[-g "!go.sum"]],
    --   -- fd_opts = [[--exclude go.sum]],
    -- },
    config = function()
      require("fzf-lua").setup({
        files = {
          -- fd_opts = "--exclude go.mod --exclude go.sum", -- Exclude go.mod and go.sum from file searches
          -- find_opts = "-type f",
          fd_opts = "--type f --hidden --exclude .git --exclude build --exclude .dart_tool --exclude node_modules --exclude .build",
          git_icons = true,
          color_icons = true,
        },
        -- git_files = {
        --   fd_opts = "--exclude go.mod --exclude go.sum", -- Exclude go.mod and go.sum from git file searches
        -- },
        -- buffers = {
        --   fd_opts = "--exclude go.mod --exclude go.sum", -- Exclude go.mod and go.sum from buffer searches
        -- },
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
