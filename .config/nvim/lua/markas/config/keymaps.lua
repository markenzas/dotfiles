local map = vim.keymap.set

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Diagnostic keymaps
map("n", "<Leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<Leader>dq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-Left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-Right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-Down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-Up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize window using <ctrl> arrow keys
map("n", "<S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<S-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<S-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Bufferline
map("n", "<Leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer Goto next" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer Goto prev" })
map("n", "<Leader>q", "<cmd>bd<CR>", { desc = "Buffer Close" })

-- Window management
map("n", "<Leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<Leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<Leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<Leader>sd", "<cmd>close<CR>", { desc = "Close current split" })

-- Execution of files and plugins
map("n", "<leader>cx", "<cmd>source %<CR>", { desc = "[C]ode [E]xecute" })

-- Neotest
map("n", "<leader>tr", "<cmd>Neotest run<CR>", { desc = "Test Current" })
map("n", "<leader>tn", "<cmd>Neotest run run<CR>", { desc = "Test Nearest" })
map("n", "<leader>tf", "<cmd>Neotest run file<CR>", { desc = "Test File" })
map("n", "<leader>ts", "<cmd>Neotest summary toggle<CR>", { desc = "Test Summary" })

map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})
