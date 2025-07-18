return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      dartls = {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = function(fname)
          -- vim.lsp.handlers["textDocument/publishDiagnostics"] =
          --   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          --     update_in_insert = false, -- Disable updates while typing
          --     underline = true,
          --     virtual_text = true,
          --     signs = true,
          --   })
          local lspconfig = require("lspconfig")
          return lspconfig.util.root_pattern("pubspec.yaml", ".git")(fname) or vim.fn.getcwd()
        end,
        -- settings = {
        --   dart = {
        --     analysisServerLogs = false,
        --     analyzerDiagnosticsPort = 0,
        --     previewLsp = true,
        --     onlyAnalyzeProjectsWithOpenFiles = true,
        --     analysisServerVmArgs = { "--disable-dart-dev" },
        --     -- analysisServerLogs = false, -- Disable extensive logs
        --     -- analyzerDiagnosticsPort = 0, -- Disable diagnostics port
        --     -- previewLsp = true, -- Enable LSP features
        --     -- analysisExcludedFolders = {
        --     --   vim.loop.cwd() .. "/build",
        --     --   vim.loop.cwd() .. "/.dart_tool",
        --     --   vim.loop.cwd() .. "/.pub-cache",
        --     --   vim.loop.cwd() .. "/android",
        --     --   vim.loop.cwd() .. "/ios",
        --     -- },
        --     -- onlyAnalyzeProjectsWithOpenFiles = true, -- Optimize analysis
        --     -- analysisServerVmArgs = {
        --     --   "--disable-dart-dev", -- Disable experimental features
        --     -- },
        --     -- runPubGetOnPubspecChanges = true,
        --     -- runPubGetOnPubspecChange = true,
        --   },
        -- },
        -- flags = {
        --   debounce_text_changes = 500, -- Reduce unnecessary processing
        -- },
        -- handlers = {
        --   ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
        --     if not result then
        --       return
        --     end
        --
        --     -- Cancel previous requests if a new one comes in
        --     local client = vim.lsp.get_client_by_id(ctx.client_id)
        --     print("client id" .. ctx.client_id)
        --     if client then
        --       client.stop() -- Stop previous runs
        --     end
        --
        --     -- Display the latest diagnostics
        --     vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        --   end,
        -- },
      },
    },
  },
}
