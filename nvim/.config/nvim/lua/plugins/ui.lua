local M = {}
local C = {} -- config

M.config = {
	{
		"folke/tokyonight.nvim",
		-- lazy = true,
		config = function()
			C.theme()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			C.lualine()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		config = function()
			C.bufferline()
		end,
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[
      _|_|_|    _|_|_|_|    _|_|_|  _|_|_|  _|      _|  
      _|    _|  _|        _|          _|    _|_|    _|  
      _|_|_|    _|_|_|    _|  _|_|    _|    _|  _|  _|  
      _|    _|  _|        _|    _|    _|    _|    _|_|  
      _|_|_|    _|_|_|_|    _|_|_|  _|_|_|  _|      _| 
    ]]

			dashboard.section.header.val = vim.split(logo, "\n")
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
				dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
				dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
				dashboard.button("l", " " .. " Lazy", ":Lazy<CR>"),
				dashboard.button("m", "󰏓 " .. " Mason", ":Mason<CR>"),
				dashboard.button("q", " " .. " Quit", ":qa<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.section.footer.opts.hl = "AlphaFooter"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}

C.lualine = function()
	require("lualine").setup({
		options = {
			icons_enabled = true,
			-- theme = "powerline_dark",
			theme = "auto",
			-- component_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			component_separators = { left = "|", right = "|" },
			section_separators = { left = " ", right = "" },
			globalstatus = true,
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
		},
		extensions = { "nvim-tree" },
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			-- lualine_x = { "searchcount", "selectioncount" },
			lualine_x = {},
			lualine_y = { "filesize", "encoding", "filetype" },
			lualine_z = { "progress", "location" },
		},
	})
end

C.bufferline = function()
	require("bufferline").setup({
		options = {
			-- 使用 nvim 内置lsp
			diagnostics = "nvim_lsp",
			-- 左侧让出 nvim-tree 的位置
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	})
end

C.theme = function()
	local status, tn = pcall(require, "tokyonight")
	if not status then
		print("Colorscheme not found!") -- print error if colorscheme not installed
		return
	end

	tn.setup({
		style = "storm",
		dim_inactive = true,
		lualine_bold = true,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
		},
	})

	vim.cmd("colorscheme tokyonight-storm")
end

return M
