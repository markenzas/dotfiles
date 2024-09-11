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
            css = { "eslint_d" },
            scss = { "eslint_d" },
            sass = { "eslint_d" },
            html = { "eslint_d" },
            php = { "php_cs_fixer" },
            json = { "prettierd", lsp_format = "fallback" },
            yaml = { "prettierd" },
            markdown = { "prettierd" },
            javascript = { "eslint_d", "prettierd", lsp_format = "fallback", stop_after_first = true },
            typescript = { "eslint_d", "prettierd", lsp_format = "fallback", stop_after_first = true },
            javascriptreact = { "eslint_d", "prettierd", lsp_format = "fallback", stop_after_first = true },
            typescriptreact = { "eslint_d", "prettierd", lsp_format = "fallback", stop_after_first = true },
            vue = { "eslint_d", "prettierd", lsp_format = "fallback", stop_after_first = true },
        },
    },
}
