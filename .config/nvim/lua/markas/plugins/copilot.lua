return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        })
    end,
}
