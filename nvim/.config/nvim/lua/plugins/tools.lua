local M = {}
local C = {}

M.config = {
	-- key tips
	"rcarriga/nvim-notify",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			C.treesitter()
		end,
	},
}

C.treesitter = function()
	-- import nvim-treesitter plugin safely
	local status, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status then
		return
	end

	-- configure treesitter
	treesitter.setup({
		-- enable indentation
		-- indent = { enable = true, disable = { "python" } },
		-- enable autotagging (w/ nvim-ts-autotag plugin)
		autotag = { enable = true },
		-- ensure these language parsers are installed
		ensure_installed = {
			-- "cpp",
			-- "rust",
			"json",
			"javascript",
			"typescript",
			-- "tsx",
			-- "yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			-- "svelte",
			-- "graphql",
			"bash",
			"lua",
			"vim",
			-- "dockerfile",
			"gitignore",
		},
		-- auto install above language parsers
		auto_install = true,
		-- List of parsers to ignore installing (for "all")
		-- ignore_install = { "javascript" },

		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			-- disable = { "c", "rust" },
			-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
			disable = function(lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
	})
end

return M
