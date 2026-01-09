local vueGotoDefinitionOpts = {
  filters = {
    auto_imports = true,
    auto_components = true,
    import_same_file = true,
    declaration = true,
    duplicate_filename = true,
  },
  filetypes = { "vue", "typescript" },
  detection = {
    nuxt = function()
      return vim.fn.glob(".nuxt/") ~= ""
    end,
    vue3 = function()
      return vim.fn.filereadable("vite.config.ts") == 1 or vim.fn.filereadable("src/App.vue") == 1
    end,
    priority = { "nuxt", "vue3" },
  },
  lsp = {
    override_definition = true, -- override vim.lsp.buf.definition
  },
  debounce = 200,
}

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump({
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                })
              end,
            },
          },
        },
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
    enabled = vim.fn.has("nvim-0.10") == 1,
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function() end,
  },
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
        },
      })
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({})

      vim.keymap.set("x", "<leader>re", ":Refactor extract ")
      vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
      vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
      vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
      vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
      vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
      vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = {
      {
        "<Leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "List locations",
      },
      {
        "<Leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Add Location",
      },
      {
        "<Leader>mr",
        function()
          require("harpoon"):list():remove()
        end,
        desc = "Remove Location",
      },
      {
        "<C-n>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Next Location",
      },
      {
        "<C-p>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Previous Location",
      },
      {
        "<Leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon to File 1",
      },
      {
        "<Leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon to File 2",
      },
      {
        "<Leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon to File 3",
      },
      {
        "<Leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon to File 4",
      },
      {
        "<Leader>5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon to File 5",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },
  {
    "catgoose/vue-goto-definition.nvim",
    event = "BufReadPre",
    opts = vueGotoDefinitionOpts,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "marilari88/neotest-vitest",
      "olimorris/neotest-phpunit",
      "nvim-neotest/neotest-go",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      require("neotest").setup({
        adapters = {
          require("neotest-vitest"),
          require("neotest-phpunit"),
          require("neotest-go"),
        },
      })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "saxon1964/neovim-tips",
    version = "*", -- Only update on tagged releases
    lazy = false, -- Load on startup for daily tip
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
      "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
      -- OR: "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
    },
    opts = {
      -- OPTIONAL: Daily tip mode (default: 1)
      daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
      -- OPTIONAL: Bookmark symbol (default: "?? ")
      bookmark_symbol = "?? ",
    },
    init = function()
      -- OPTIONAL: Change to your liking or drop completely
      -- The plugin does not provide default key mappings, only commands
      local map = vim.keymap.set
      map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", silent = true })
      map("n", "<leader>nte", ":NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips", silent = true })
      map("n", "<leader>nta", ":NeovimTipsAdd<CR>", { desc = "Add your Neovim tip", silent = true })
      map("n", "<leader>nth", ":help neovim-tips<CR>", { desc = "Neovim tips help", silent = true })
      map("n", "<leader>ntr", ":NeovimTipsRandom<CR>", { desc = "Show random tip", silent = true })
      map("n", "<leader>ntp", ":NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF", silent = true })
    end,
  },
}
