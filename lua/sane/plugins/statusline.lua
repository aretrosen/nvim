return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local noice = require "noice"

      local mode_to_sgn = {
        ["NORMAL"] = "ℕ",
        ["VISUAL"] = "∨",
        ["V-LINE"] = "",
        ["V-BLOCK"] = "",
        ["COMMAND"] = "ℂ",
        ["CONFIRM"] = "ꏸ",
        ["REPLACE"] = "ᚱ",
        ["V-REPLACE"] = "ℝ",
        ["INSERT"] = "Ĭ",
        ["EX"] = "Ē",
        ["MORE"] = "ᛖ",
        ["O-PENDING"] = "Ō",
        ["SELECT"] = "§",
        ["S-LINE"] = "Տ",
        ["S-BLOCK"] = "ꌚ",
        ["SHELL"] = "ℤ",
        ["TERMINAL"] = "₸",
      }

      require("lualine").setup {
        options = {
          theme = "kanagawa",
          globalstatus = true,
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            { "fileformat", separator = { left = "" }, padding = 0 },
            {
              "mode",
              fmt = function(str)
                return mode_to_sgn[str]
              end,
              padding = 1,
              separator = {},
            },
          },
          lualine_b = {
            { "overseer" },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              symbols = {
                modified = " ",
                readonly = " ",
                newfile = " ",
              },
            },
          },
          lualine_c = {
            {
              "branch",
              icon = "",
              separator = "",
              on_click = function()
                vim.cmd "Telescope git_branches"
                vim.cmd "e!"
              end,
            },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              separator = "",
              on_click = function()
                vim.cmd "DiffviewOpen -uno"
              end,
            },
            { "%=", separator = "" },
            {
              "diagnostics",
              symbols = {
                error = " ",
                warn = " ",
                hint = "󰌵 ",
                info = " ",
              },
              on_click = function()
                vim.cmd "TroubleToggle document_diagnostics"
              end,
            },
          },
          lualine_x = {
            {
              noice.api.status.search.get,
              cond = noice.api.status.search.has,
              color = { fg = "#89DCEB" },
            },
          },
          lualine_y = {
            "encoding",
            { "progress", separator = {} },
          },
          lualine_z = {
            {
              "location",
              fmt = function(str)
                return "" .. str
              end,
              separator = { right = "" },
              padding = { right = 0, left = 1 },
            },
          },
        },
        extensions = { "neo-tree", "symbols-outline" },
      }
    end,
  },
}
