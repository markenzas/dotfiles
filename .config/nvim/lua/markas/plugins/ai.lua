return {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
        local neocodeium = require("neocodeium")
        neocodeium.setup({
            filetypes = {
                TelescopePrompt = false,
                ["dap-repl"] = false,
            },
        })
        vim.keymap.set("i", "<A-f>", neocodeium.accept)
    end,
}
