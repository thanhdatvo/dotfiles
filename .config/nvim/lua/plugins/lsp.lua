return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.filetype.add({
      extension = {
        tsrx = "ripple",
      },
    })
  end,
  opts = {
    servers = {
      yamlls = {
        settings = {
          yaml = {
            validate = true,
            completion = true,
            hover = true,
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = {
              kubernetes = {
                "k8s/*.yaml",
                "k8s/*.yml",
                "manifests/*.yaml",
                "manifests/*.yml",
                "*.k8s.yaml",
                "*.k8s.yml",
              },
            },
          },
        },
      },
      dartls = {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("pubspec.yaml", ".git")(fname) or vim.fn.getcwd()
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

      ripple = {
        cmd = { "ripple-language-server", "--stdio" },
        filetypes = { "ripple" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("ripple.config.ts", "vite.config.ts", "package.json", ".git")(
            fname
          )
        end,
      },
    },
  },
}
