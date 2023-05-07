return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        transparent_background = true,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          functions = { "bold" },
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          harpoon = true,
          leap = true,
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
          barbecue = {
            dim_dirname = true,
          },
          neotree = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          vimwiki = true,
          notify = true,
          indent_blankline = {
            enabled = true,
          },
        },
      }
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
