return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
              ["ui.inlayhint.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        vtsls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          settings = {
            complete_function_calls = true,
            vtsls = {
              tsserver = { globalPlugins = {} },
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            javascript = {
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
          before_init = function(params, config)
            local result = vim
              .system({ "npm", "query", "#vue" }, { cwd = params.workspaceFolders[1].name, text = true })
              :wait()
            if result.stdout ~= "[]" then
              local vuePluginConfig = {
                name = "@vue/typescript-plugin",
                location = require("mason-registry").get_package("vue-language-server"):get_install_path()
                  .. "/node_modules/@vue/language-server",
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              }
              table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
            end
          end,
        },
      }
      servers.vtsls.settings["js/ts"] = { implicitProjectConfig = { checkJs = true } }

      vim.lsp.inlay_hint.enable(true)
      vim.diagnostic.config({ virtual_text = true })

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
        "gopls",
        "vtsls",
        "vue-language-server",
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local lspconfig = require("lspconfig")
            local opts = servers[server_name] or {}
            opts.lspcapabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
            lspconfig[server_name].setup(opts)
          end,
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
