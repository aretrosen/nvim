return {
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "tpope/vim-characterize",
    keys = "ga",
  },
  {
    "tzachar/local-highlight.nvim",
    ft = { "python", "cpp", "c", "rust" },
    event = "VeryLazy",
    opts = { file_types = { "python", "cpp", "c", "rust" } },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      {
        "<F5>",
        "<cmd>UndotreeToggle<cr>",
        desc = "Undotree",
      },
    },
  },
  {
    "smjonas/live-command.nvim",
    event = "VeryLazy",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
          Reg = {
            cmd = "norm",
            args = function(opts)
              return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
            end,
            range = "",
          },
        },
      }
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sr",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    keys = {
      {
        "<leader>ps",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>pl",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>pd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    config = true,
  },
  { "krady21/compiler-explorer.nvim", cmd = "CECompile" },
  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
    keys = {
      { "gA", "<Plug>(EasyAlign)", desc = "Vim Alignemnet", mode = { "n", "x" } },
    },
  },
  "nvim-lua/plenary.nvim",
  {
    dir = "~/.config/nvim/lua_plugins/sudowrite.nvim",
    event = "VeryLazy",
    config = true,
  },
}
