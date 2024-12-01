return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("catppuccin")
            vim.cmd.hi("comment gui=none")
        end,
    },
    -- {
    --     "shaunsingh/nord.nvim",
    --     name = "nord",
    --     priority = 1000,
    --     init = function()
    --         vim.cmd.colorscheme("nord")
    --         vim.cmd.hi("comment gui=none")
    --     end,
    -- },
}
