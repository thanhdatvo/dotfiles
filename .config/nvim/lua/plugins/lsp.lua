return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.filetype.add({
      extension = {
        tsrx = "ripple",
        -- tsrx = "tsrx",
        -- ripple = "ripple",
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ripple",
      callback = function()
        vim.lsp.start({
          name = "ripple",
          cmd = { "ripple-language-server", "--stdio" },
          root_dir = vim.fs.root(0, {
            "ripple.config.ts",
            "ripple.config.js",
            "vite.config.ts",
            "vite.config.js",
            "package.json",
            ".git",
          }),
        })
      end,
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
      -- dartls = {
      --   cmd = { "dart", "language-server", "--protocol=lsp" },
      --   filetypes = { "dart" },
      --   root_dir = function(fname)
      --     return require("lspconfig.util").root_pattern("pubspec.yaml", ".git")(fname) or vim.fn.getcwd()
      --   end,
      -- },

      -- pyright = {
      --   settings = {
      --     pyright = {
      --       disableOrganizeImports = true,
      --     },
      --     python = {
      --       analysis = {
      --         ignore = { "*" },
      --       },
      --     },
      --   },
      -- },
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },

      ruff = {},
      -- ripple = {
      --   cmd = { "ripple-language-server", "--stdio" },
      --   filetypes = { "ripple" },
      --   root_dir = function(fname)
      --     return require("lspconfig.util").root_pattern(
      --       "ripple.config.ts",
      --       "ripple.config.js",
      --       "vite.config.ts",
      --       "vite.config.js",
      --       "package.json",
      --       ".git"
      --     )(fname)
      --   end,
      -- },
    },
    setup = {
      ruff = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("disable_ruff_hover", { clear = true }),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)

            if client and client.name == "ruff" then
              client.server_capabilities.hoverProvider = false
            end
          end,
        })
      end,
    },
  },
}
