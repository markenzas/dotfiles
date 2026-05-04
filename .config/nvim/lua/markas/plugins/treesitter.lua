return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash",
        "c",
        "lua",
        "markdown",
        "vim",
        "vimdoc",
        "go",
        "gdscript",

        -- NOTE: Webdev
        "html",
        "css",
        "blade",
        "php",
        "blade",
        "python",
        "dockerfile",
        "graphql",
        "json",
        "prisma",
        "javascript",
        "typescript",
        "tsx",
        "vue",

        -- NOTE: DevOps
        "dockerfile",
        "yaml",
        "terraform",
      },
    })
  end,
}
