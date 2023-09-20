local opt = vim.opt

-- 基础
opt.encoding = "utf-8"
-- vim.cmd("syntax on")
-- vim.cmd("filetype plugin indent on")
-- vim.cmd("nohlsearch") -- needless
opt.number = true
opt.relativenumber = true -- 相对行号
opt.wildmenu = true -- vim命令自动补全，忽略大小写
vim.opt.updatetime = 100
opt.history = 500
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.termguicolors = true
-- if (vim.fn.has('termguicolors') == 1) then
--   opt.termguicolors = true
-- end

-- 搜索
-- vim.opt.hlsearch = true  -- needless
-- vim.opt.incsearch = true -- needless
opt.ignorecase = true -- 忽略大小写
opt.smartcase = true -- 智能大小写（对于只有一个大写字母的搜索词，将大小写敏感）
-- vim.opt.showmatch = true

-- tabs & indentation
opt.tabstop = 2 -- 默认缩进2个空格
opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
-- opt.softtabstop = 2  -- 使用tab的空格数,number of spaces that <Tab> uses while editing
-- vim.opt.cindent = true
-- vim.opt.smartindent = true

-- list
opt.list = true
opt.listchars = {
	tab = "▸ ",
	trail = "■",
}

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- 编辑
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.cursorline = true -- 高亮光标所在行
opt.scrolloff = 10 -- 光标到上下边距空5行
-- opt.wrap = true
-- opt.ruler = true
opt.autowrite = true
opt.autoread = true
opt.formatoptions = ""
opt.spell = true -- 拼写检查
opt.spelllang = { "en_us" }
-- vim.opt.tw = 0
-- vim.opt.backspace = "indent,eol,start"
-- vim.opt.foldmethod = "indent"
-- vim.opt.foldlevel = 99
-- vim.opt.laststatus = 2
-- vim.opt.autochdir = true
-- vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
-- vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
-- vim.opt.lazyredraw = false
-- vim.opt.compatible = false
-- vim.opt.shell = "/bin/bash"
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.swapfile = true
opt.backup = true
opt.undofile = true -- 撤销历史保留
opt.undodir = vim.fn.expand("~/.tmp/nvim/undo") -- undo历史文件
opt.directory = vim.fn.expand("~/.tmp/nvim/swap")
opt.backupdir = vim.fn.expand("~/.tmp/nvim/bak")
-- vim.opt.writebackup = false
--
-- vim.opt.shortmess:append({ c = true })
-- vim.opt.whichwrap:append({ ["<"] = true, [">"] = true, [","] = true, h = true, l = true })
-- vim.cmd([[set iskeyword+=-]]) -- 连字符不再视为一个单词
opt.iskeyword:append("-") -- consider string-string as whole word

-- User autocmd
local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

au("TextYankPost", {
	group = ag("yank_highlight", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 }) -- yy高亮300ms
	end,
	desc = "Highlight the texts when you yanked",
})

au({ "BufReadPost" }, {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.api.nvim_exec("normal! g'\"", false)
		end
	end,
	desc = "再次打开文件，光标在上次关闭位置",
})

au({ "VimResized" }, {
	group = ag("resize_splits", {}),
	pattern = "*",
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	desc = "Resize splits if window got resized",
})

au({ "BufWritePre" }, {
	group = ag("auto_create_dir", {}),
	pattern = "*",
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
})

au({ "FileType" }, {
	pattern = "*",
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
	desc = "Disables automatic commenting on newline",
})

-- 自动转换输入法
local input_toggle = 0
function Fcitx2en()
	local input_status = tonumber(io.popen("fcitx5-remote"):read("*all"))
	if input_status == 1 then
		os.execute("fcitx5-remote -o")
		input_toggle = 1
	end
end
function Fcitx2zh()
	local input_status = tonumber(io.popen("fcitx5-remote"):read("*all"))
	if input_status == 2 and input_toggle == 1 then
		os.execute("fcitx5-remote -c")
	end
end
au(
	{ "InsertEnter" },
	{ pattern = "*", command = "lua Fcitx2zh()", desc = "插入模式切换为打开 vim 时的输入法模式" }
)
au({ "InsertLeave" }, { pattern = "*", command = "lua Fcitx2en()", desc = "normal 模式切换为英文输入法" })
au({ "VimEnter" }, { pattern = "*", command = "lua Fcitx2en()", desc = "进入 vim 切换为英文输入法" })
au({ "ExitPre" }, { pattern = "*", command = "lua Fcitx2zh()", desc = "退出 vim 切换为原输入法模式" })
