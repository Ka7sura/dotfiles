-- 插件管理器初始化
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- 插件使用
lazy.setup({
	require("plugins.lsp").config,
	require("plugins.ui").config,
	require("plugins.snippets"),
	require("plugins.codeing").config,
	require("plugins.file"),
	require("plugins.autocomplete").config,
	require("plugins.find").config,
	require("plugins.tools").config,
})
