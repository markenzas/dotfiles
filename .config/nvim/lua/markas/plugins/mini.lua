return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
      },
    },
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left = "<M-h>",
        down = "<M-j>",
        up = "<M-k>",
        right = "<M-l>",
        line_right = "<M-h>",
        line_left = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
    },
  },
  {
    "echasnovski/mini.jump",
    event = "VeryLazy",
    config = function()
      require("mini.jump").setup({})
    end,
  },
}
