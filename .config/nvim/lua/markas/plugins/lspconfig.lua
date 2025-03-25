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
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        vim.lsp.set_log_level("off"),
        require("vim.lsp.log").set_format_func(vim.inspect),

        callback = function(event)
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
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
        volar = {
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = {
                  enabled = true,
                },
                functionLikeReturnTypes = {
                  enabled = true,
                },
                propertyDeclarationTypes = {
                  enabled = true,
                },
                parameterTypes = {
                  enabled = true,
                  suppressWhenArgumentMatchesName = true,
                },
                variableTypes = {
                  enabled = true,
                },
              },
            },
          },
        },
        vtsls = {
          tsserver = {
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "typescript", "javascript", "vue" },
                },
              },
            },
            filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
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
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
