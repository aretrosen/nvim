return {
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "tpope/vim-characterize",
    keys = "ga",
  },
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
  },
  { "chaoren/vim-wordmotion", event = "VeryLazy" },
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
    "numToStr/FTerm.nvim",
    cmd = "Gitui",
    keys = {
      {
        "<A-t>",
        [[<cmd>lua require("FTerm").toggle()<cr>]],
        desc = "Toggle FTerm",
      },
      {
        "<A-t>",
        [[<c-\><c-n><cmd>lua require("FTerm").toggle()<cr>]],
        mode = "t",
        desc = "Toggle FTerm",
      },
    },
    config = function()
      local fterm = require "FTerm"
      local gitui = fterm:new {
        ft = "fterm_gitui",
        cmd = "gitui",
      }
      vim.api.nvim_create_user_command("Gitui", function()
        gitui:toggle()
      end, { desc = "Open Gitui" })
    end,
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = "markdown",
    keys = {
      {
        "<leader>mo",
        function()
          local peek = require "peek"
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "light" },
  },
  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    config = true,
  },
  { "krady21/compiler-explorer.nvim", cmd = "CECompile" },
  {
    "jbyuki/nabla.nvim",
    ft = { "tex", "text", "markdown" },
    keys = {
      {
        "<leader>np",
        function()
          require("nabla").popup { border = "rounded" }
        end,
        desc = "Latex Expression Popup",
      },
    },
  },
  "nvim-lua/plenary.nvim",
  { "famiu/bufdelete.nvim", event = "VeryLazy" },
  {
    "sQVe/sort.nvim",
    cmd = "Sort",
  },
}
