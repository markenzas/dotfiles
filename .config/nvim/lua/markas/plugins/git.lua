return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "󰍵" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "│" },
            },

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function opts(desc)
                    return { buffer = bufnr, desc = desc }
                end

                local map = vim.keymap.set

                map("n", "<Leader>gr", gs.reset_hunk, opts("Reset Hunk"))
                map("n", "<Leader>gh", gs.preview_hunk, opts("Preview Hunk"))
                map("n", "<Leader>gB", gs.blame_line, opts("Blame Line"))
                map("n", "<Leader>gd", gs.diffthis, opts("Diff this"))
            end,
        },
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open [G]it" },
        },
    },
    {
        "pwntester/octo.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("octo").setup()
        end,
    },
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewClose",
        },
    },
}
