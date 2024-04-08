return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }

            return {
                timeout_ms = 1000,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                async = false,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            css = { "prettierd" },
            html = { "prettierd" },
            php = { "php_cs_fixer" },
            json = { "prettierd" },
            yaml = { "prettierd" },
            markdown = { "prettierd" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            go = { "goimports", "gofmt" },
        },
    },
}
