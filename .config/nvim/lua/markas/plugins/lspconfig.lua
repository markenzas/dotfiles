local LspAction = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
        settings = {
          tsserver_plugins = {
            "@vue/typescript-plugin",
          },
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        volar = { "vue" },
      }

      vim.lsp.inlay_hint.enable(true)

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "clangd",
        "markdownlint",
        "html-lsp",
        "cssls",
        "eslint_d",
        "prettierd",
        "pint",
        "phpactor",
        "prismals",
        "vtsls",
        "vue-language-server", -- Vue
        "gopls",
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local lspconfig = require("lspconfig")
            local opts = servers[server_name] or {}
            opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
            lspconfig[server_name].setup(opts)
          end,
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        vim.lsp.set_log_level("off"),
        require("vim.lsp.log").set_format_func(vim.inspect),

        callback = function(event)
          -- Bug fix for tailwindcss completion LSP crashes
          for _, client in pairs((vim.lsp.get_clients({}))) do
            if client.name == "tailwindcss" then
              client.server_capabilities.completionProvider.triggerCharacters =
                { '"', "'", "`", ".", "(", "[", "!", "/", ":" }
            end
          end

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          --  To jump back, press <C-t>.
          map("K", vim.lsp.buf.hover, "Hover Documentation")

          map("<leader>cr", vim.lsp.buf.rename, "Code Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>lr", "<cmd>LspRestart<CR>", "LSP Restart")
          map("<leader>lf", "<cmd>LspInfo<CR>", "LSP Info")

          map("<leader>co", LspAction["source.organizeImports"], "Organize Imports")
          map("<leader>ci", LspAction["source.addMissingImports.ts"], "Add missing imports")
          map("<leader>cu", LspAction["source.removeUnused.ts"], "Remove unused imports")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
