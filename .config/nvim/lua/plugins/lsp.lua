return {
  "neovim/nvim-lspconfig",
  -- opts = function(_, opts)
  --   for _, server in pairs(opts.servers or {}) do
  --     server.capabilities = server.capabilities or {}
  --     server.capabilities.semanticTokensProvider = nil
  --   end
  -- end,
  opts = {
    servers = {
      nil_ls = {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "alejandra" },
            },
          },
        },
      },
      dartls = {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = function(fname)
          local lspconfig = require("lspconfig")
          return lspconfig.util.root_pattern("pubspec.yaml", ".git")(fname) or vim.fn.getcwd()
        end,
      },
    },
  },
}
