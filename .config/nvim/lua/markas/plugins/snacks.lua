return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
      preset = {
        header = [[
██╗  ██╗██╗    ███╗   ███╗ █████╗ ██████╗ ██╗  ██╗
██║  ██║██║    ████╗ ████║██╔══██╗██╔══██╗██║ ██╔╝
███████║██║    ██╔████╔██║███████║██████╔╝█████╔╝ 
██╔══██║██║    ██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗ 
██║  ██║██║    ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██╗
╚═╝  ╚═╝╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
                ]],
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Open Lazygit",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "[G]it [o]pen file in a browser",
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "[G]it [b]lame Line",
    },
    {
      "<leader>nh",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Show [n]otification [h]istory",
    },

    {
      "<leader>nd",
      function()
        Snacks.notifier.hide()
      end,
      desc = "[N]otification [d]ismiss",
    },
  },
}
