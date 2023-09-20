local M = {}
local C = {}

M.config = {
	-- LSP
	{ -- lsp包管理
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			C.mason()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- 将mason与laspconfig包联结起来
			config = function()
				C.mason_lsp()
			end,
		},
	},
	{ -- better ui for lsp
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({})
			C.lspsaga()
		end,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		},
	},

	-- linter && formatter
	{
		"jose-elias-alvarez/null-ls.nvim", -- engine
		event = { "BufReadPre", "BufNewFile" },
		-- enabled = false,
		dependencies = {
			{ "jay-babu/mason-null-ls.nvim" },
			{ "mason.nvim" },
		}, --combine with mason
		config = function()
			C.null_ls()
		end,
	},

	-- DAP
	{ "rcarriga/nvim-dap-ui" },
	{
		"mfussenegger/nvim-dap",
		config = function()
			C.dap()
		end,
	},
	{ "jay-babu/mason-nvim-dap.nvim" },
	{ -- virtual text for the debugger
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}

C.lsp = function() end

C.lspsaga = function()
	local map = vim.keymap.set -- for conciseness
	local opts = { noremap = true, silent = true }
	map("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	map("n", "gD", "<Cmd>Lspsaga goto_definition<CR>", opts) -- got to declaration
	map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	map("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>") -- Peek type definition
	map("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>") -- Go to type definition
	-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- Rename all occurrences of the hovered word for the entire file
	map("n", "<leader>RN", "<cmd>Lspsaga rename ++project<CR>") -- Rename all occurrences of the hovered word for the selected files
	map("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	map("n", "<leader>D", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	-- map("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")      -- Show buffer diagnostics
	map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- Toggle outline
	map("n", "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", opts) -- Floating terminal
	-- Diagnostic jump with filters such as only jumping to an error
	map("n", "[D", function()
		require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end)
	map("n", "]D", function()
		require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
	end)
	-- Call hierarchy
	map("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
	map("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
end

C.mason = function()
	local mason_status, mason = pcall(require, "mason")
	if not mason_status then
		return
	end
	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
end

C.mason_lsp = function()
	local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not mason_lspconfig_status then
		return
	end
	mason_lspconfig.setup({
		ensure_installed = { "lua_ls", "pyright", "html", "bashls" },
		automatic_installation = false,
	})

	mason_lspconfig.setup_handlers({
		function(server_name) -- default handler (optional)
			require("lspconfig")[server_name].setup({})
		end,
		-- ["rust_analyzer"] = function()
		-- 	require("rust-tools").setup({})
		-- end,
	})
end

C.null_ls = function()
	local setup, null_ls = pcall(require, "null-ls")
	if not setup then
		return
	end
	local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
	if not mason_null_ls_status then
		return
	end
	local formatting = null_ls.builtins.formatting -- to setup formatters
	local diagnostics = null_ls.builtins.diagnostics -- to setup linters

	mason_null_ls.setup({
		ensure_installed = { "stylua", "jq" },
	})
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		sources = {
			--  to disable file types use
			--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
			-- formatting.prettier, -- js/ts formatter
			formatting.stylua, -- lua formatter
			formatting.shfmt,
			formatting.jq,
			formatting.black,
			formatting.latexindent,
			diagnostics.shellcheck,
			-- diagnostics.eslint_d.with({ -- js/ts linter
			--   -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
			--   condition = function(utils)
			--     return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
			--   end,
			-- }),
		},
		-- configure format on save
		on_attach = function(current_client, bufnr)
			if current_client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							filter = function(client)
								--  only use null-ls for formatting instead of lsp server
								return client.name == "null-ls"
							end,
							bufnr = bufnr,
						})
					end,
				})
			end
		end,
	})
end

C.dap = function()
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup()

	local m = { noremap = true }
	vim.keymap.set("n", "<leader>'q", ":Telescope dap<CR>", m)
	vim.keymap.set("n", "<leader>'t", dap.toggle_breakpoint, m)
	vim.keymap.set("n", "<leader>'n", dap.continue, m)
	vim.keymap.set("n", "<leader>'s", dap.terminate, m)
	vim.keymap.set("n", "<leader>'u", dapui.toggle, m)

	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define("DapLogPoint", {
		text = "",
		texthl = "DapLogPoint",
		linehl = "DapLogPoint",
		numhl = "DapLogPoint",
	})
	vim.fn.sign_define(
		"DapStopped",
		{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
	)
end

return M
