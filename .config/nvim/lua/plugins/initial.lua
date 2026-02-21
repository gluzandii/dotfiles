-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "habamax",
    },
  },
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  { "hrsh7th/nvim-cmp", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "yaml",
        "xml",
        "toml",
        "sql",
        "lua",
        "markdown",
        "markdown_inline",
        "regex",
        "rust",
        "go",
        "vim",
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "eslint_d",
        "rust-analyzer",
        "gopls",
        "taplo",
        "yaml-language-server",
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "sqls",
      },
    },
  },
}
