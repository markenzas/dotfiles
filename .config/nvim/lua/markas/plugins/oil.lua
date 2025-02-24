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
      view_options = {
        show_hidden = true,
      },
    })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>e",
      [[<cmd>lua require("oil").toggle_float()<CR>]],
      { noremap = true, silent = true, desc = "Toggle Oil float" }
    )
  end,
}
