return {
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
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
  { "chaoren/vim-wordmotion", event = "VeryLazy" },
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
  },
}
