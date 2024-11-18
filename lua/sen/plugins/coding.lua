if vim.g.vscode then
	return {}
end

return {
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				opts = {
					impersontate_nvim_cmp = true,
				},
			},
		},
		build = "cargo build --release",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			sources = {
				completion = {
					enabled_providers = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"lazydev",
					},
				},
				providers = {
					lazydev = {
						name = "lazydev",
						module = "blink.compat.source",
						score_offset = 3,
						opts = {},
					},
				},
			},
			keymap = "super-tab",
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			nerd_font_variant = "normal",
			-- experimental auto-brackets support
			accept = { auto_brackets = { enabled = true } },
			-- experimental signature help support
			trigger = { signature_help = { enabled = true } },
			windows = {
				autocomplete = {
					border = "rounded",
				},
				documentation = {
					border = "rounded",
				},
				-- ghost_text = {
				-- 	enabled = true,
				-- },
				signature_help = {
					border = "rounded",
				},
			},
		},
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
		},
		config = function(_, opts)
			local pairs = require("mini.pairs")
			pairs.setup(opts)
			local open = pairs.open
			pairs.open = function(pair, neigh_pattern)
				if vim.fn.getcmdline() ~= "" then
					return open(pair, neigh_pattern)
				end
				local o, c = pair:sub(1, 1), pair:sub(2, 2)
				local line = vim.api.nvim_get_current_line()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local next = line:sub(cursor[2] + 1, cursor[2] + 1)
				local before = line:sub(1, cursor[2])
				if o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
					return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
				end
				if next ~= "" and next:match(opts.skip_next) then
					return o
				end
				if opts.skip_ts and #opts.skip_ts > 0 then
					local ok, captures =
						pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
					for _, capture in ipairs(ok and captures or {}) do
						if vim.tbl_contains(opts.skip_ts, capture.capture) then
							return o
						end
					end
				end
				if next == c and c ~= o then
					local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
					local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
					if count_close > count_open then
						return o
					end
				end
				return open(pair, neigh_pattern)
			end
		end,
	},
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta" },
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		opts = {
			-- add any opts here
		},
		build = "make",
		dependencies = {
			"nvim-treesitter",
			"dressing.nvim",
			"plenary.nvim",
			"MunifTanjim/nui.nvim",
			"img-clip.nvim",
		},
	},
}
