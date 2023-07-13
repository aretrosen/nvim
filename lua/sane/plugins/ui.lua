return {
  "nvim-tree/nvim-web-devicons",
  {
    "lewis6991/foldsigns.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              {
                sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
                click = "v:lua.ScSa",
              },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
              {
                sign = { name = { ".*" }, maxwidth = 1, auto = true, wrap = true },
                click = "v:lua.ScSa",
              },
            },
          }
        end,
      },
    },
    config = true,
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local icon, color = require("nvim-web-devicons").get_icon_color(filename)
        return {
          { icon, guifg = color },
          { " " },
          { filename, guifg = color },
        }
      end,
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 1500,
      render = "compact",
      stages = "fade",
      background_colour = "#000000",
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
  { "lewis6991/whatthejump.nvim", event = "VeryLazy" },
  -- {
  --   "folke/edgy.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
}
