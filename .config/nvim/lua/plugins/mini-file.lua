return {
  {
    "nvim-mini/mini.files",
    version = false,
    keys = {
      { "<leader>fm", false },
      {
        "<F3>",
        function()
          -- require("mini.files").open(vim.api.nvim_buf_get_name(0), true)

          local MiniFiles = require("mini.files")
          if MiniFiles.close() then
            return
          end

          MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
        -- width_focus = 30,
        -- width_nofocus = 20,
        -- width_preview = 40,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.api.nvim_buf_call(args.data.buf_id, function()
            -- highlight MiniFilesFile guifg=#ABB2BF
            -- highlight MiniFilesDirectory guifg=#82AAFF
            vim.cmd([[
            ]])
          end)
        end,
      })
    end,
  },
}
