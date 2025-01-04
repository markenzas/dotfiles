return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    })

    -- Open parent dir in current window
    vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    -- Open parent dir in floating window
    vim.keymap.set("n", "-", require("oil").toggle_float)
  end,
}
