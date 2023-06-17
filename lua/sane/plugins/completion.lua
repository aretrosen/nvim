return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "amarakon/nvim-cmp-lua-latex-symbols",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
      "clangd_extensions.nvim",
      "tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      local kind_icons = {
        Array = "",
        Boolean = "",
        Class = "ﴯ",
        Color = "",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "ﰠ",
        File = "",
        Folder = "",
        Function = "󰊕",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "󰊕",
        Module = "",
        Namespace = "",
        Null = "",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "פּ",
        Text = "󰉿",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
      }

      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            item = require("tailwindcss-colorizer-cmp").formatter(entry, item)
            local icon = kind_icons[item.kind] or "???"
            local src = ({
              buffer = "[buf]",
              nvim_lsp = "[lsp]",
              luasnip = "[snip]",
              latex_symbols = "[tex]",
            })[entry.source.name] or ""
            item.menu = string.format("%s %s", "(" .. item.kind:lower() .. ")", src)
            item.kind = icon
            return item
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "lua-latex-symbols", option = { cache = true } },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "clangd_extensions.cmp_scores",
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      cmp.setup.filetype("lua", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }, {
          { name = "path" },
        }, {
          { name = "lua-latex-symbols", option = { cache = true } },
        }),
      })

      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          cmp.setup.buffer { sources = { { name = "crates" } } }
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {
      color_square_width = 2,
    },
  },
  {
    "altermo/ultimate-autopair.nvim",
    event = "InsertEnter",
    config = true,
  },
}
