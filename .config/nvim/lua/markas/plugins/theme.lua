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
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "<leader>b", group = "[B]uffer" },
            { "<leader>c", group = "[C]ode" },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>e", group = "[E]xplorer" },
            { "<leader>f", group = "[F]ind" },
            { "<leader>g", group = "[G]it" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>t", group = "[T]est" },
            { "<leader>w", group = "[W]orkspace" },
            { "<leader>x", group = "[X]trouble" },
        },
    },
    {
        "sphamba/smear-cursor.nvim",
        opts = {},
    },
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                render = "foreground",
                named_colors = true,
                enable_tailwind = true,
            })
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local lualine = require("lualine")
            local lazy_status = require("lazy.status") -- to configure lazy pending updates count

            local colors = {
                blue = "#65D1FF",
                green = "#3EFFDC",
                violet = "#FF61EF",
                yellow = "#FFDA7B",
                red = "#FF4A4A",
                fg = "#c3ccdc",
                bg = "#112638",
                inactive_bg = "#2c3043",
            }

            local my_lualine_theme = {
                normal = {
                    a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                },
                insert = {
                    a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                },
                visual = {
                    a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                },
                command = {
                    a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                },
                replace = {
                    a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                    b = { bg = colors.bg, fg = colors.fg },
                    c = { bg = colors.bg, fg = colors.fg },
                },
                inactive = {
                    a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
                    b = { bg = colors.inactive_bg, fg = colors.semilightgray },
                    c = { bg = colors.inactive_bg, fg = colors.semilightgray },
                },
            }

            -- configure lualine with modified theme
            lualine.setup({
                options = {
                    theme = my_lualine_theme,
                },
                sections = {
                    lualine_a = {
                        {
                            "filename",
                            file_status = true,
                            newfile_status = false,
                            path = 1,
                            shorting_target = 40,
                            symbols = {
                                modified = "[+]",
                                readonly = "[-]",
                                unnamed = "[No Name]",
                                newfile = "[New]",
                            },
                        },
                    },
                    lualine_x = {
                        {
                            lazy_status.updates,
                            cond = lazy_status.has_updates,
                            color = { fg = "#ff9e64" },
                        },
                        { "encoding" },
                        { "fileformat" },
                        { "filetype" },
                    },
                },
            })
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "center",
                        },
                    },
                },
            })
        end,
    },
}
