return {
  {
    "nvim-mini/mini.ai",
    version = "*",
    opts = { n_lines = 500 },
  },
  {
    "nvim-mini/mini.surround",
    version = "*",
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
    "nvim-mini/mini.move",
    version = "*",
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
    "nvim-mini/mini.jump",
    version = "*",
    config = function()
      require("mini.jump").setup({})
    end,
  },
  {
    "nvim-mini/mini.diff",
    version = "*",
  },
}
