return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        vim.lsp.set_log_level("trace"),
        require("vim.lsp.log").set_format_func(vim.inspect),

        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("<leader>lr", "<cmd>LspRestart<CR>", "[L]SP [R]estart")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
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
        ts_ls = {
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
      }

      -- Inlay Hints
      local opts = { noremap = true, silent = true }
      vim.keymap.set({ "n" }, "gI", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, opts)

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "clangd",
        "markdownlint",
        "html-lsp",
        "eslint_d",
        "prettierd",
        "phpactor",
        "php-cs-fixer",
        "prismals",
        "ts_ls",
        "tailwindcss",
        "vue-language-server", -- Vue
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
    end,
  },
}
