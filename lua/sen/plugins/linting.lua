return {
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		opts = {
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				bash = { "shellcheck" },
				cmake = { "cmakelint" },
				dockerfile = { "hadolint" },
				elixir = { "credo" },
				go = { "goimports", "gofumpt" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
				-- ["*"] = { "typos" },
			},
			linters = {
				-- -- Example of using selene only when a selene.toml file is present
				-- selene = {
				--   -- `condition` is another LazyVim extension that allows you to
				--   -- dynamically enable/disable linters based on the context.
				--   condition = function(ctx)
				--     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
				--   end,
				-- },
			},
		},
		config = function(_, opts)
			local lint = require("lint")
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = opts.linters_by_ft

			local debounce = function(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			local lint = function()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)
				names = vim.list_extend({}, names)

				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				if #names > 0 then
					lint.try_lint(names)
				end
			end

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = debounce(100, lint),
			})
		end,
	},
}
