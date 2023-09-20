local M = {}
M.config = {
	{
		"L3MON4D3/LuaSnip", -- snippets engine
		version = "<CurrentMajor>.*", -- follow latest release.
		build = "make install_jsregexp", -- install jsregexp (optional!).
		dependencies = {
			"rafamadriz/friendly-snippets", -- useful snippets
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- use nvim-lsp to autocomplete
			"saadparwaiz1/cmp_luasnip", -- snippets sources from nvim-cmp
			"hrsh7th/cmp-buffer", -- from buffer
			"hrsh7th/cmp-path", -- from path
			"hrsh7th/cmp-cmdline",
			-- "octaltree/cmp-look", -- for English word
		},
		config = function()
			M.configfunc()
		end,
	},
}

M.configfunc = function()
	local cmp_status, cmp = pcall(require, "cmp")
	if not cmp_status then
		return
	end

	local luasnip_status, luasnip = pcall(require, "luasnip")
	if not luasnip_status then
		return
	end

	-- local cmp = require("cmp")
	-- local luasnip = require("luasnip")

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			-- ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
			["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			["<C-e>"] = cmp.mapping.abort(), -- close completion window
			-- ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<CR>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					else
						fallback()
					end
				end,
			}),
			["<S-Tab>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
					else
						fallback()
					end
				end,
			}),
		}),
		-- 	s = cmp.mapping.confirm({ select = true }),
		-- 	c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		-- }),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "buffer" }, -- text within current buffer
		}, {
			{ name = "path" }, -- file system paths
			{ name = "luasnip" }, -- For luasnip users.
		}),
	})

	-- Set configuration for specific filetype.
	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
		}, {
			{ name = "buffer" },
		}),
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return M
