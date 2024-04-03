return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "lua",
            "markdown",
            "vim",
            "vimdoc",
            "go",

            -- NOTE: Webdev
            "html",
            "css",
            "php",
            "python",
            "json",
            "javascript",
            "typescript",
            "tsx",
        },

        highlight = {
            enable = true,
        },
        indent = { enable = true },
    },
    config = function()
        -- [[ Configure Treesitter ]] See `:help nvim-treesitterhttps://github.com/nvim-treesitter/nvim-treesitter-textobjects`

        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
            context = {
                enable = true,
                max_lines = 1,
            },
        })
    end,
}
