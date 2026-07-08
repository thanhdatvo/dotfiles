return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {},
  run = ":TSUpdate",

  -- init = function()
  --   local parser_path = vim.fn.expand("~/.local/share/nvim/site/parser/tsrx.so")
  --
  --   vim.treesitter.language.add("tsrx", {
  --     path = parser_path,
  --   })
  --
  --   vim.treesitter.language.register("tsrx", "tsrx")
  --   vim.filetype.add({
  --     extension = {
  --       tsrx = "tsrx",
  --     },
  --   })
  -- end,
  --
  -- config = function()
  --   local parsers = require("nvim-treesitter.parsers")
  --
  --   parsers.tsrx = {
  --     install_info = {
  --       url = "https://github.com/Xander-de-Keijzer/tree-sitter-tsrx",
  --       files = { "src/parser.c", "src/scanner.c" },
  --       branch = "main",
  --       revision = "main",
  --     },
  --     tier = 3,
  --   }
  -- end,

  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "css",
      "dart",
      "diff",
      "dockerfile",
      "dtd",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "hcl",
      "helm",
      "html",
      "hurl",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "ninja",
      "nu",
      "printf",
      "python",
      "query",
      "regex",
      "ripple",
      "ron",
      "rst",
      "rust",
      "sql",
      "svelte",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "tsx",

      -- custom parser
      --      "tsrx",
    },
    highlight = {
      -- enable = false,
    },
  },
}
