return {
  "nvim-tree/nvim-web-devicons",
  "MunifTanjim/nui.nvim",
  "folke/twilight.nvim",
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  { "uga-rosa/ccc.nvim", cmd = "CccPick" },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 1500,
      render = "compact",
      stages = "fade",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      vim.notify = function(...)
        return require "notify"(...)
      end
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        css = true,
        tailwind = true,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      filetype_exclude = { "help", "neo-tree", "Trouble", "lazy" },
      show_current_context = true,
      show_current_context_start = true,
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "stevearc/dressing.nvim",
    init = function()
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "barrett-ruth/import-cost.nvim",
    ft = { "javascriptreact", "typescriptreact" },
    build = "sh install.sh pnpm",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    config = true,
  },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { "g<C-a>", mode = "v" },
      { "g<C-x>", mode = "v" },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.constant.alias.Alpha,
          augend.constant.alias.alpha,
          augend.constant.alias.bool,
          augend.date.alias["%H:%M"],
          augend.date.alias["%H:%M:%S"],
          augend.date.alias["%Y-%m-%d"],
          augend.integer.alias.binary,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.semver.alias.semver,
          augend.hexcolor.new {
            case = "lower",
          },
          augend.date.new {
            pattern = "%-I:%M %p",
            default_kind = "min",
            only_valid = true,
          },
          augend.date.new {
            pattern = "%B:%-d, %Y",
            default_kind = "day",
            clamp = false,
            end_sensitive = true,
            only_valid = true,
          },
        },
      }
      local map = vim.keymap.set
      local dialmap = require "dial.map"
      map("n", "<C-a>", dialmap.inc_normal(), { noremap = true })
      map("n", "<C-x>", dialmap.dec_normal(), { noremap = true })
      map("v", "<C-a>", dialmap.inc_visual(), { noremap = true })
      map("v", "<C-x>", dialmap.dec_visual(), { noremap = true })
      map("v", "g<C-a>", dialmap.inc_gvisual(), { noremap = true })
      map("v", "g<C-x>", dialmap.dec_gvisual(), { noremap = true })
    end,
  },
}
