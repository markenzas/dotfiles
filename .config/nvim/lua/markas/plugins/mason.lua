return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "stylua",
      "clangd",
      "html",
      "cssls",
      "tailwindcss",
      "phpactor",
      "prismals",
      "gopls",
      "vtsls",
      "vue_ls",
    },
    automatic_enable = {
      exclude = {
        "markdownlint",
        "eslint_d",
        "prettierd",
        "pint",
      },
    },
  },
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    "neovim/nvim-lspconfig",
  },
}
