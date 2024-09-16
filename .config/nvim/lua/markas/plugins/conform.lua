local with_prettier = { "prettierd", lsp_format = "fallback" }
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
            lua = { "stylua", lsp_format = "fallback" },
            css = with_prettier,
            scss = with_prettier,
            sass = with_prettier,
            html = with_prettier,
            php = { "php_cs_fixer" },
            json = with_prettier,
            yaml = with_prettier,
            markdown = with_prettier,
            javascript = with_prettier,
            typescript = with_prettier,
            javascriptreact = with_prettier,
            typescriptreact = with_prettier,
            vue = with_prettier,
        },
    },
}
