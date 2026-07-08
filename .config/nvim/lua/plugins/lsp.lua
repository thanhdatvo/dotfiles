return {
  "neovim/nvim-lspconfig",
  -- init = function()
  --   vim.filetype.add({
  --     extension = {
  --       -- tsrx = "ripple",
  --       tsrx = "tsrx",
  --       -- ripple = "ripple",
  --     },
  --   })
  -- end,
  -- config = function()
  --   vim.lsp.config("ripple", {
  --     cmd = { "ripple-language-server", "--stdio" },
  --     filetypes = { "ripple", "tsrx" },
  --     root_markers = {
  --       "ripple.config.ts",
  --       "vite.config.ts",
  --       "package.json",
  --       ".git",
  --     },
  --   })
  --
  --   vim.lsp.config("vtsls", {
  --     cmd = { "vtsls", "--stdio" },
  --     filetypes = {
  --       "javascript",
  --       "javascriptreact",
  --       "typescript",
  --       "typescriptreact",
  --     },
  --     root_markers = {
  --       "package.json",
  --       "tsconfig.json",
  --       "jsconfig.json",
  --       ".git",
  --     },
  --   })
  --   vim.lsp.enable({ "vtsls", "ripple" })
  --   -- vim.lsp.enable({ "ripple" })
  -- end,
  opts = {
    servers = {

      -- vtsls = {
      --   filetypes = {
      --     "javascript",
      --     "javascriptreact",
      --     "typescript",
      --     "typescriptreact",
      --     "tsrx",
      --   },
      -- },

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
      -- vtsls = {
      --   filetypes = {
      --     "javascript",
      --     "javascriptreact",
      --     "typescript",
      --     "typescriptreact",
      --     "tsrx",
      --   },
      -- },
      -- ripple = {
      --   cmd = { "ripple-language-server", "--stdio" },
      --   filetypes = { "ripple", "tsrx" },
      --   root_dir = function(fname)
      --     return require("lspconfig.util").root_pattern("ripple.config.ts", "vite.config.ts", "package.json", ".git")(
      --       fname
      --     )
      --   end,
      -- },
      ripple = {
        cmd = { "ripple-language-server", "--stdio" },
        filetypes = { "ripple", "tsrx" },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("ripple.config.ts", "vite.config.ts", "package.json", ".git")(
            fname
          )
        end,
      },
    },
  },
}
