local transparent = true
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
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
            enable_ui = true, -- enable nvim-dap-ui
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
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
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
      vim.cmd.colorscheme "github_dark"
    end,
  },
}
