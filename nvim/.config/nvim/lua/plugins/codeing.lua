local M = {}
local C = {}

M.config = {
	{
		"voldikss/vim-translator", -- 翻译插件，不好用，句子翻译失败
	},
	{
		"potamides/pantran.nvim", -- other translate plugin for sentence
		enabled = false,
		config = function()
			C.pantran()
		end,
	},
	{
		"lambdalisue/suda.vim", -- sudo 提权
	},
	{
		"numToStr/Comment.nvim", -- gcc/gc 快速注释
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"windwp/nvim-autopairs", -- autopairs
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
}

C.pantran = function()
	local pantran_status, pantran = pcall(require, "pantran")
	if not pantran_status then
		return
	end

	pantran.setup({
		-- Default engine to use for translation. To list valid engine names run
		-- `:lua =vim.tbl_keys(require("pantran.engines"))`.
		default_engine = "google",
		-- Configuration for individual engines goes here.
		engines = {
			google = {
				-- Default languages can be defined on a per engine basis. In this case
				-- `:lua require("pantran.async").run(function()
				-- vim.pretty_print(require("pantran.engines").yandex:languages()) end)`
				-- can be used to list available language identifiers.
				default_source = "en",
				default_target = "zh",
			},
		},
		controls = {
			mappings = {
				edit = {
					n = {
						-- Use this table to add additional mappings for the normal mode in
						-- the translation window. Either strings or function references are
						-- supported.
						["j"] = "gj",
						["k"] = "gk",
					},
					i = {
						-- Similar table but for insert mode. Using 'false' disables
						-- existing keybindings.
						["<C-y>"] = false,
						["<C-a>"] = require("pantran.ui.actions").yank_close_translation,
					},
				},
				-- Keybindings here are used in the selection window.
				select = {
					n = {
						-- ...
					},
				},
			},
		},
	})
end

return M
