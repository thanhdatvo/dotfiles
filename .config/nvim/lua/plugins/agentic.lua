return {
  "carlos-algms/agentic.nvim",
  opts = {
    -- provider = "opencode-acp",
    provider = "claude-agent-acp",

    diff_preview = {
      enabled = true,
      layout = "split", -- "split" or "inline"
      center_on_navigate_hunks = true,
    },
    auto_scroll = {
      threshold = -1,
    },
    headers = {
      chat = function(parts, session_state)
        -- local header = parts.title
        local header = ""

        if not session_state then
          return header
        end

        local used = session_state:get_context_used()
        local size = session_state:get_context_size()
        local cost = session_state:get_cost_amount()
        local currency = session_state:get_cost_currency()

        if used then
          header = header .. " | " .. used

          if size then
            header = header .. " / " .. size
          end

          header = header .. " tokens"
        end

        if cost then
          header = header .. " | " .. (currency and currency .. " " or "") .. cost
        end

        return header
      end,
    },
  },

  keys = {
    {
      "<leader>aa",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v", "i" },
      desc = "Toggle Agentic Chat",
    },
    {
      "<leader>ac",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Agentic",
    },
    {
      "<leader>an",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v", "i" },
      desc = "New Agentic Session",
    },
    {
      "<leader>ar",
      function()
        require("agentic").restore_session()
      end,
      mode = { "n", "v", "i" },
      desc = "Restore Agentic Session",
    },
    {
      "<leader>ad",
      function()
        require("agentic").add_current_line_diagnostics()
      end,
      mode = "n",
      desc = "Add Current Diagnostic",
    },
    {
      "<leader>aD",
      function()
        require("agentic").add_buffer_diagnostics()
      end,
      mode = "n",
      desc = "Add Buffer Diagnostics",
    },
  },
}
