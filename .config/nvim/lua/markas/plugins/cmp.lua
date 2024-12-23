return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" }, { "rafamadriz/friendly-snippets" } },
  version = "*",
  opts = {
    keymap = { preset = "default" },
    signature = { enabled = true },
    completion = {
      keyword = { range = "full" },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
        },
      },
    },
    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,

      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,

      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },
    sources = {
      default = { "lsp", "path", "luasnip", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
