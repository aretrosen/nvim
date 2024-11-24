if vim.g.vscode then
	return {}
end
return {
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 2000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		opts = {
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 2000 }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				-- # Example of using dprint only when a dprint.json file is present
				-- dprint = {
				--   condition = function(ctx)
				--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
				--
				-- # Example of using shfmt with extra args
				shfmt = {
					prepend_args = { "-i", "2", "-ci" },
				},
			},
		},
	},
}
