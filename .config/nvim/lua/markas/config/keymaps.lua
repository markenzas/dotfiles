local map = vim.keymap.set

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<Leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

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
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("n", "<Leader>fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- Nvimtree
map("n", "<Leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree Toggle Window" })
map("n", "<Leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Nvimtree Toggle Window on current file" })

-- Bufferline
map("n", "<Leader>bn", "<cmd>enew<CR>", { desc = "Buffer New" })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer Goto next" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer Goto prev" })
map("n", "<Leader>bx", "<cmd>bd<CR>", { desc = "Buffer Close" })

-- Window management
map("n", "<Leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<Leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<Leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<Leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Blankline
map("n", "<Leader>bl", function()
    local config = { scope = {} }
    config.scope.exclude = { language = {}, node_type = {} }
    config.scope.include = { node_type = {} }
    local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

    if node then
        local start_row, _, end_row, _ = node:range()
        if start_row ~= end_row then
            vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
            vim.api.nvim_feedkeys("_", "n", true)
        end
    end
end, { desc = "Blankline Jump to current context" })

-- Git | vim-fugitive
map("n", "<Leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame file " })

-- Navigate between nvim & tmux
map("n", "<C-k>", ":windcmd k<CR>", { desc = "Move focus to the upper window" })
map("n", "<C-j>", ":windcmd j<CR>", { desc = "Move focus to the lower window" })
map("n", "<C-h>", ":windcmd h<CR>", { desc = "Move focus to the left window" })
map("n", "<C-l>", ":windcmd l<CR>", { desc = "Move focus to the right window" })

-- Vim Test
map("n", "<Leader>tt", "<cmd>TestNearest<CR>", { desc = "Test Nearest" })
map("n", "<Leader>tf", "<cmd>TestFile<CR>", { desc = "Test File" })
map("n", "<Leader>ts", "<cmd>TestSuite<CR>", { desc = "Test Suite" })
map("n", "<Leader>tl", "<cmd>TestLast<CR>", { desc = "Test Last" })
map("n", "<Leader>tv", "<cmd>TestVisit<CR>", { desc = "Test Visit" })

-- Noice.nvim
map("n", "<Leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

-- Copilot chat
map("n", "<Leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "[C]opilot [C]hat Open" })
map("n", "<Leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "[C]opilot [E]xplain Selection" })
map("n", "<Leader>cr", "<cmd>CopilotChatReview<CR>", { desc = "[C]opilot [R]eview Selection" })
map("n", "<Leader>ct", "<cmd>CopilotChatTests<CR>", { desc = "[C]opilot generate [T]ests" })
map("n", "<Leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "[C]opilot [F]ix diagnostic issue in file" })
