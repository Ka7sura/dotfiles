return {
	"L3MON4D3/LuaSnip", -- snippets engine
	version = "<CurrentMajor>.*", -- follow latest release.
	build = "make install_jsregexp", -- install jsregexp (optional!).
	dependencies = {
		"saadparwaiz1/cmp_luasnip", -- snippets sources from nvim-cmp
		"rafamadriz/friendly-snippets", -- useful snippets
	},
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
