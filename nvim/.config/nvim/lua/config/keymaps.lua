local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua <cr>", opts)

--- local set = vim.keymap.set

local map = vim.keymap.set

map("n", "S", ":w<CR>", opts)
map("n", "Z", ":q<CR>", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
-- vim.keymap.set('n', '<leader>dw', '/\(\<\w\+\>\)\_s*\1<CR>')
map("n", "<F9>", ":nohlsearch<CR>", opts)
map("i", "jk", "<esc>", opts)
map("n", ";", ":", opts)
map("n", "<leader>sc", ":set spell!<cr>", opts)
map("n", "<leader>sw", ":set wrap!<cr>", opts)

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- split screen
map("n", "sk", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { desc = "Split up" }, opts)
map("n", "sj", ":set splitbelow<CR>:split<CR>", { desc = "Split down" }, opts)
map("n", "sh", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { desc = "Split left" }, opts)
map("n", "sl", ":set splitright<CR>:vsplit<CR>", { desc = "Split right" }, opts)
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<leader>k", "<cmd>m .-2<cr>==", { desc = "Move Lines up" })
map("n", "<leader>j", "<cmd>m .+1<cr>==", { desc = "Move Lines down" })
-- map("i", "<leader>j", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "<leader>k", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<leader>j", ":m '>+1<cr>gv=gv", { desc = "Move Lines down" })
map("v", "<leader>k", ":m '<-2<cr>gv=gv", { desc = "Move Lines up" })

-- replace what you highlight
vim.keymap.set("v", "p", '"_dP', opts)

-- buffer
map("n", "bh", ":bp<cr>", { desc = "Go buffer left" }, opts)
map("n", "bl", ":bn<cr>", { desc = "Go buffer right" }, opts)
map("n", "bc", ":bd<cr>", { desc = "Rm buffer withput save" }, opts)
map("n", "bw", ":bd!<cr>", { desc = "Rm buffer and save" }, opts)

--
-- plusins
--

-- nvim-tree
map("n", "tt", ":NvimTreeToggle<cr>", { desc = "Toggle nvimtree" }, opts)

-- nvim-translator
map("n", "<Leader>t", ":Translate<cr>", { desc = "Echo translation in the cmdline" })
map("v", "<Leader>t", ":TranslateV<cr>", { desc = "Echo translation in the cmdline" })
map("n", "<Leader>w", ":TranslateW<cr>", { desc = "Display translation in a window" })
map("v", "<Leader>w", ":TranslateWV<cr>", { desc = "Display translation in a window" })
map("n", "<Leader>r", ":TranslateR<cr>", { desc = "Replace the text with translation" })
map("v", "<Leader>r", ":TranslateRV<cr>", { desc = "Replace the text with translation" })
map("n", "<Leader>x", ":TranslateX<cr>", { desc = "Translate the text in clipboard" })

-- local pantran_status, pantran = pcall(require, "pantran")
-- if not pantran_status then
-- 	return
-- end
--
-- vim.keymap.set("n", "<leader>tr", pantran.motion_translate, { noremap = true, silent = true, expr = true })
-- vim.keymap.set("n", "<leader>trr", function()
-- 	return pantran.motion_translate() .. "_"
-- end, opts)
-- vim.keymap.set("x", "<leader>tr", pantran.motion_translate, opts)

-- telescope
-- local builtin = require("telescope.builtin")
-- map("n", "<leader>ff", builtin.find_files, {})
-- map("n", "<leader>fg", builtin.live_grep, {})
-- map("n", "<leader>fb", builtin.buffers, {})
-- map("n", "<leader>fh", builtin.help_tags, {})

-- -- quickfix and location fix
-- vim.keymap.set("n", "co", ":copen<cr>", opts)
-- vim.keymap.set("n", "cj", ":cnext<cr>", opts)
-- vim.keymap.set("n", "ck", ":cprevious<cr>", opts)
-- vim.keymap.set("n", "cc", ":cclose<cr>", opts)
--
-- vim.keymap.set("n", "zo", ":lopen<cr>", opts)
-- vim.keymap.set("n", "zj", ":lnext<cr>", opts)
-- vim.keymap.set("n", "zk", ":lprevious<cr>", opts)
-- vim.keymap.set("n", "zc", ":lclose<cr>", opts)

-- suda
map("n", "<C-s>", ":SudaWrite<cr>")
