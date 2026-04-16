return {
  "neovim/nvim-lspconfig",
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
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              ignore = { "*" },
            },
          },
        },
      },
    },
  },
}
