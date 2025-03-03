return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-Left>", "<cmd>TmuxNavigateLeft<CR>" },
    { "<C-Down>", "<cmd>TmuxNavigateDown<CR>" },
    { "<C-Up>", "<cmd>TmuxNavigateUp<CR>" },
    { "<C-Right>", "<cmd>TmuxNavigateRight<CR>" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>" },
  },
}
