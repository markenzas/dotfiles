local with_prettier = { "prettierd", "prettier", lsp_format = "fallback" }

return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    css = with_prettier,
                    html = with_prettier,
                    javascript = with_prettier,
                    javascriptreact = with_prettier,
                    json = with_prettier,
                    lua = { "stylua" },
                    markdown = with_prettier,
                    typescript = with_prettier,
                    typescriptreact = with_prettier,
                    vue = with_prettier,
                },
            })

            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end

                conform.format({ async = true, lsp_fallback = true, range = range })
            end, { range = true })
        end,
    },
}
