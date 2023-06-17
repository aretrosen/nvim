local transparent = true
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    -- lazy = false,
    -- priority = 1000,
    config = function()
      require("catppuccin").setup {
        transparent_background = transparent,
        dim_inactive = {
          enabled = not transparent,
        },
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          functions = { "bold" },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          harpoon = true,
          lsp_trouble = true,
          mason = true,
          symbols_outline = true,
          fidget = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          dap = {
            enabled = true,
            enable_ui = true,
          },
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          vimwiki = true,
          notify = true,
        },
      }
      -- vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    -- lazy = false,
    -- priority = 1000,
    config = function()
      require("gruvbox").setup {
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {},
        dim_inactive = not transparent,
        transparent_mode = transparent,
      }
      -- vim.cmd.colorscheme "gruvbox"
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    -- lazy = false,
    -- priority = 1000,
    config = function()
      require("kanagawa").setup {
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = { bold = true },
        transparent = transparent,
        dimInactive = not transparent,
        terminalColors = true,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      }
      -- vim.cmd.colorscheme "kanagawa"
    end,
  },
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup {
        style = "vulgaris",
        transparent = transparent,
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "bold",
          strings = "none",
          variables = "none",
        },
        lualine = {
          transparent = transparent,
        },
      }
      require("bamboo").load()
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    -- lazy = false,
    -- priority = 1000,
    config = function()
      require("github-theme").setup {
        options = {
          transparent = transparent,
          dim_inactive = not transparent,
          styles = {
            comments = "italic",
            conditionals = "italic",
            functions = "bold",
          },
          inverse = {
            visual = true,
          },
          modules = {
            cmp = true,
            fidget = true,
            gitsigns = true,
            lsp_trouble = true,
            notify = true,
            telescope = true,
            treesitter_context = true,
          },
          darken = {
            floats = true,
            sidebars = {
              enabled = true,
              list = { "qf", "Outline" },
            },
          },
        },
      }
      -- vim.cmd.colorscheme "github_dark"
    end,
  },
}
