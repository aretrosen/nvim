return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  "HiPhish/nvim-ts-rainbow2",
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPost",
    opts = {
      autotag = {
        enable = true,
        filetypes = { "html", "xml", "markdown" },
      },
    },
  },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },
  {
    "mfussenegger/nvim-treehopper",
    keys = {
      {
        "m",
        [[:<C-U>lua require('tsht').nodes()<CR>]],
        mode = "o",
      },
      {
        "m",
        [[:lua require('tsht').nodes()<CR>]],
        mode = "x",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "LiadOz/nvim-dap-repl-highlights", config = true },
      { "tjdevries/ocaml.nvim", config = true },
    },
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "arduino",
          "astro",
          "awk",
          "bash",
          "bibtex",
          "c",
          "clojure",
          "cmake",
          "cpp",
          "css",
          "cuda",
          "diff",
          "dap_repl",
          "dockerfile",
          "eex",
          "elixir",
          "erlang",
          "fortran",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "glsl",
          "go",
          "gomod",
          "gosum",
          "gowork",
          "graphql",
          "hcl",
          "html",
          "http",
          "ini",
          "java",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "kotlin",
          "latex",
          "llvm",
          "lua",
          "luadoc",
          "luap",
          "make",
          "markdown",
          "markdown_inline",
          "meson",
          "ninja",
          "ocaml",
          "ocaml_interface",
          "ocamllex",
          "perl",
          "prisma",
          "proto",
          "python",
          "query",
          "rasi",
          "regex",
          "rst",
          "rust",
          "scala",
          "scss",
          "solidity",
          "sql",
          "terraform",
          "todotxt",
          "toml",
          "tsx",
          "typescript",
          "verilog",
          "vim",
          "vimdoc",
          "wgsl",
          "wgsl_bevy",
          "yaml",
          "yuck",
          "zig",
        },
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = false,
        },
        matchup = {
          enable = true,
          enable_quotes = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        rainbow = {
          enable = true,
          query = "rainbow-parens",
          strategy = require "ts-rainbow.strategy.global",
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        playground = {
          enable = true,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
        },
      }
      local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    cmd = { "STSSelectParentNode", "STSSelectChildNode" },
    keys = {
      { "H", "<cmd>STSSelectParentNode<cr>", desc = "Select Parent Node", mode = "x" },
      { "L", "<cmd>STSSelectChildNode<cr>", desc = "Select Child Node", mode = "x" },
      {
        "<leader>gs",
        "<cmd>STSSwapOrHoldVisual<cr>",
        desc = "Swap Currently Held Node",
        mode = "x",
      },
      {
        "go",
        function()
          require("syntax-tree-surfer").targeted_jump {
            "function",
            "arrow_function",
            "if_statement",
            "else_clause",
            "else_statement",
            "elseif_statement",
            "for_statement",
            "while_statement",
            "switch_statement",
          }
        end,
        desc = "Targeted Jump",
      },
    },
    config = true,
  },
  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<F4>", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "<leader>cc",
        function()
          local action = require("ts-node-action.actions").cycle_case()[1][1]
          local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
          vim.lsp.buf.rename(action(node))
        end,
        desc = "Apply cycle_case node action via LSP Rename",
      },
    },
    config = true,
  },
  {
    "bennypowers/nvim-regexplainer",
    dependencies = { "nui.nvim" },
    keys = "gE",
    opts = {
      mappings = {
        toggle = "gE",
      },
      -- filetypes (i.e. extensions) in which to run the autocommand
      filetypes = {
        "html",
        "js",
        "cjs",
        "mjs",
        "ts",
        "jsx",
        "tsx",
        "cjsx",
        "mjsx",
        "rs",
        "c",
        "cc",
        "cpp",
        "h",
        "pl",
        "lua",
      },
    },
  },
}
