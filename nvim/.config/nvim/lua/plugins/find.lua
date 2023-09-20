local M = {}
local C = {}

M.config = {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		config = function()
			C.telescope()
		end,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
	},
}

C.telescope = function()
	local status, telescope = pcall(require, "telescope")
	if not status then
		vim.notify("没有找到 telescope")
		return
	end

	-- local actions = require("telescope.actions")
	telescope.setup({
		defaults = {
			-- 打开弹窗后进入的初始模式，默认为 insert，也可以是 normal
			initial_mode = "insert",
			-- vertical , center , cursor
			layout_strategy = "horizontal",
			-- 窗口内快捷键
			-- mappings = require("keybindings").telescopeList,
		},
		pickers = {
			find_files = {
				-- theme = "dropdown", -- 可选参数： dropdown, cursor, ivy
			},
		},
		extensions = {
			-- ["ui-select"] = {
			-- 	require("telescope.themes").get_dropdown({
			-- 		-- even more opts
			-- 	}),
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	})
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	telescope.load_extension("fzf")

	-- pcall(telescope.load_extension, "env")
	-- To get ui-select loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
	-- pcall(telescope.load_extension, "ui-select")
end

return M
