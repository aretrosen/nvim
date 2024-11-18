if vim.g.vscode then
	return {}
end

return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		opts = {
			show_end_of_buffer = true,
			term_colors = true,
			integrations = {
				fidget = true,
				flash = true,
				fzf = true,
				gitsigns = true,
				grug_far = true,
				harpoon = true,
				indent_blankline = {
					enabled = true,
					scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
					colored_indent_levels = false,
				},
				markdown = true,
				mini = {
					enabled = true,
					indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
				},
				blink_cmp = true,
				dap = true,
				dap_ui = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
					inlay_hints = {
						background = true,
					},
				},
				notify = true,
				semantic_tokens = true,
				nvim_surround = true,
				treesitter_context = true,
				treesitter = true,
				rainbow_delimiters = true,
				lsp_trouble = true,
				which_key = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			stages = "fade_in_slide_out",
			render = "compact",
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(...)
				return require("notify")(...)
			end
		end,
	},
	{
		"echasnovski/mini.icons",
		opts = {
			file = {
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "mini.icons" },
		event = "VeryLazy",
		opts = {
			options = {
				globalstatus = true,
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = {
			scope = { show_exact_scope = true },
			exclude = {
				filetypes = {
					"help",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
				},
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"nanozuki/tabby.nvim",
		event = "VeryLazy",
		dependencies = "mini.icons",
		opts = {
			preset = "active_wins_at_tail",
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			sign = { enabled = false },
			virtual_text = { enabled = true },
		},
	},
	{
		"stevearc/quicker.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"stevearc/qf_helper.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"OXY2DEV/foldtext.nvim",
		event = "VimEnter",
	},
	{
		"OXY2DEV/helpview.nvim",
		ft = "help",
		dependencies = {
			"nvim-treesitter",
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose" },
		opts = {},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"plenary.nvim",
			"fzf-lua",
			"diffview.nvim",
		},
		cmd = { "Neogit" },
		opts = {},
	},
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown", "Avante" },
		dependencies = { "nvim-treesitter", "mini.icons" },
		opts = {
			-- hybrid_modes = { "n" },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "VeryLazy",
		init = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},
}
