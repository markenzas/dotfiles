return { -- Fuzzy Finder (files, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({
            path_display = { "smart" },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
            live_grep = {
                file_ignore_patterns = { "node_modules" },
                additional_args = function(_)
                    return { "--hidden" }
                end,
            },
            find_files = {
                file_ignore_patterns = { "node_modules" },
                hidden = true,
            },
        })

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
        vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
        vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set("n", "<leader>f/", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "[F]ind [/] in Open Files" })

        -- Shortcut for sinding your Neovim configuration files
        vim.keymap.set("n", "<leader>fn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[F]ind [N]eovim files" })
    end,
}
