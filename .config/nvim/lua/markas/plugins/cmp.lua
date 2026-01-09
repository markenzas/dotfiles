return {
  "saghen/blink.cmp",
  dependencies = { "Kaiser-Yang/blink-cmp-avante", "rafamadriz/friendly-snippets", "onsails/lspkind.nvim" },
  version = "1.*",
  opts = {
    keymap = { preset = "default" },

    cmdline = {
      enabled = false,
    },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = {
            { "kind_icon", "label", gap = 1 },
            { "kind" },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require("lspkind").symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
              end,

              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },

            label = {
              text = function(item)
                return item.label
              end,
              highlight = "CmpItemAbbr",
            },
            kind = {
              text = function(item)
                return item.kind
              end,
              highlight = "CmpItemKind",
            },
          },
        },
      },
    },

    sources = {
      default = { "avante", "lsp", "path", "snippets", "buffer" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            kind_icons = {
              AvanteCmd = "",
              AvanteMention = "",
              AvanteShortcut = "",
            },
          },
        },
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
