local parsers_to_install = {
  "bash",
  "c",
  "lua",
  "markdown",
  "vimdoc",
  "go",
  "gdscript",
  -- Webdev
  "html",
  "css",
  "blade",
  "php",
  "python",
  "dockerfile",
  "graphql",
  "json",
  "prisma",
  "javascript",
  "typescript",
  "tsx",
  "vue",
  -- DevOps
  "yaml",
  "terraform",
}

return {
  -- Parser management (must not be lazy-loaded)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(parsers_to_install)

      -- Enable treesitter highlighting and indentation for supported filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local swap = require("nvim-treesitter-textobjects.swap")
      local move = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select keymaps
      local select_maps = {
        ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
        ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
        ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
        ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },
        ["a:"] = { "@property.outer", "Select outer part of an object property" },
        ["i:"] = { "@property.inner", "Select inner part of an object property" },
        ["l:"] = { "@property.lhs", "Select left part of an object property" },
        ["r:"] = { "@property.rhs", "Select right part of an object property" },
        ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
        ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },
        ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
        ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },
        ["al"] = { "@loop.outer", "Select outer part of a loop" },
        ["il"] = { "@loop.inner", "Select inner part of a loop" },
        ["af"] = { "@call.outer", "Select outer part of a function call" },
        ["if"] = { "@call.inner", "Select inner part of a function call" },
        ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
        ["im"] = { "@function.inner", "Select inner part of a method/function definition" },
        ["ac"] = { "@class.outer", "Select outer part of a class" },
        ["ic"] = { "@class.inner", "Select inner part of a class" },
      }

      for key, mapping in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(mapping[1], "textobjects")
        end, { desc = mapping[2] })
      end

      -- Swap next
      local swap_next = {
        ["<leader>na"] = { "@parameter.inner", "Swap parameter/argument with next" },
        ["<leader>n:"] = { "@property.outer", "Swap object property with next" },
        ["<leader>nm"] = { "@function.outer", "Swap function with next" },
      }
      for key, mapping in pairs(swap_next) do
        vim.keymap.set("n", key, function()
          swap.swap_next(mapping[1])
        end, { desc = mapping[2] })
      end

      -- Swap previous
      local swap_prev = {
        ["<leader>pa"] = { "@parameter.inner", "Swap parameter/argument with prev" },
        ["<leader>p:"] = { "@property.outer", "Swap object property with prev" },
        ["<leader>pm"] = { "@function.outer", "Swap function with previous" },
      }
      for key, mapping in pairs(swap_prev) do
        vim.keymap.set("n", key, function()
          swap.swap_previous(mapping[1])
        end, { desc = mapping[2] })
      end

      -- Move keymaps
      local nxo = { "n", "x", "o" }

      local next_start = {
        ["]f"] = { "@call.outer", "textobjects", "Next function call start" },
        ["]m"] = { "@function.outer", "textobjects", "Next method/function def start" },
        ["]c"] = { "@class.outer", "textobjects", "Next class start" },
        ["]i"] = { "@conditional.outer", "textobjects", "Next conditional start" },
        ["]l"] = { "@loop.outer", "textobjects", "Next loop start" },
        ["]s"] = { "@local.scope", "locals", "Next scope" },
        ["]z"] = { "@fold", "folds", "Next fold" },
      }
      for key, m in pairs(next_start) do
        vim.keymap.set(nxo, key, function()
          move.goto_next_start(m[1], m[2])
        end, { desc = m[3] })
      end

      local next_end = {
        ["]F"] = { "@call.outer", "Next function call end" },
        ["]M"] = { "@function.outer", "Next method/function def end" },
        ["]C"] = { "@class.outer", "Next class end" },
        ["]I"] = { "@conditional.outer", "Next conditional end" },
        ["]L"] = { "@loop.outer", "Next loop end" },
      }
      for key, m in pairs(next_end) do
        vim.keymap.set(nxo, key, function()
          move.goto_next_end(m[1], "textobjects")
        end, { desc = m[2] })
      end

      local prev_start = {
        ["[f"] = { "@call.outer", "Prev function call start" },
        ["[m"] = { "@function.outer", "Prev method/function def start" },
        ["[c"] = { "@class.outer", "Prev class start" },
        ["[i"] = { "@conditional.outer", "Prev conditional start" },
        ["[l"] = { "@loop.outer", "Prev loop start" },
      }
      for key, m in pairs(prev_start) do
        vim.keymap.set(nxo, key, function()
          move.goto_previous_start(m[1], "textobjects")
        end, { desc = m[2] })
      end

      local prev_end = {
        ["[F"] = { "@call.outer", "Prev function call end" },
        ["[M"] = { "@function.outer", "Prev method/function def end" },
        ["[C"] = { "@class.outer", "Prev class end" },
        ["[I"] = { "@conditional.outer", "Prev conditional end" },
        ["[L"] = { "@loop.outer", "Prev loop end" },
      }
      for key, m in pairs(prev_end) do
        vim.keymap.set(nxo, key, function()
          move.goto_previous_end(m[1], "textobjects")
        end, { desc = m[2] })
      end
    end,
  },

  -- Sticky context at top of buffer
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 1,
    },
  },
}
