return {
  "alex35mil/pi.nvim",

  -- Optional: required only for `:PiPasteImage` (clipboard image paste).
  dependencies = { "HakonHarnes/img-clip.nvim" },

  config = function()
    pi = require("pi")
    -- Preserve plugin defaults
    pi.setup({})

    -- Global mappings — open / toggle / resume from anywhere.
    vim.keymap.set({ "n", "v" }, "<Leader>pp", function()
      vim.cmd("Pi layout=side")
    end, { desc = "Pi side" })
    vim.keymap.set({ "n", "v" }, "<Leader>pf", function()
      vim.cmd("Pi layout=float")
    end, { desc = "Pi float" })
    vim.keymap.set({ "n", "v" }, "<Leader>pl", "<Cmd>PiToggleLayout<CR>", { desc = "Pi toggle layout" })
    vim.keymap.set({ "n", "v" }, "<Leader>pc", "<Cmd>PiContinue<CR>", { desc = "Pi continue last session" })
    vim.keymap.set({ "n", "v" }, "<Leader>pr", "<Cmd>PiResume<CR>", { desc = "Pi resume past session" })
    vim.keymap.set({ "n", "v" }, "<Leader>pm", "<Cmd>PiSendMention<CR>", { desc = "Pi mention file/selection" })
    vim.keymap.set({ "n", "v" }, "<Leader>pa", "<Cmd>PiAttention<CR>", { desc = "Pi open next attention request" })

    -- Ask about the visual selection or cursor position.
    vim.keymap.set({ "n", "x" }, "<leader>a", function()
      local path = vim.api.nvim_buf_get_name(0)
      -- Open Pi if needed
      pi.show()

      -- Then send current file / selection context
      vim.schedule(function()
        pi.send_mention({
          path = path,
        })
      end)
    end, {
      desc = "Ask Pi about selection",
    })
  end,
}
