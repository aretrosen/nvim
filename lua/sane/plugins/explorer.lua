return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon mark a file",
      },
      {
        "<leader>hq",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon quick menu",
      },
      {
        "<leader>hn",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "Harpoon go to next file",
      },
      {
        "<leader>hp",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "Harpoon go to prev file",
      },
    },
    config = true,
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-project.nvim" },
  { "imNel/monorepo.nvim", config = true },
  { "ThePrimeagen/git-worktree.nvim" },
  { "smartpde/telescope-recent-files" },
  {
    "ThePrimeagen/refactoring.nvim",
    config = true,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = "yaml",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      {
        "<leader>fb",
        function()
          require("telescope").extensions.file_browser.file_browser {
            path = vim.lsp.buf.list_workspace_folders()[1] or "%:p:h",
          }
        end,
        desc = "Telescope File Browser (root dir)",
      },
      {
        "<leader>fr",
        function()
          require("telescope").extensions.recent_files.pick(
            require("telescope.themes").get_dropdown {}
          )
        end,
        desc = "Telescope Recent Files",
      },
      {
        "<leader>tp",
        function()
          require("telescope").extensions.project.project {}
        end,
        desc = "Telescope Projects",
      },
      {
        "<leader>tr",
        function()
          require("telescope").extensions.monorepo.monorepo()
        end,
        desc = "Telescope Projects",
      },
      { "<leader>km", "<cmd>Telescope keymaps<cr>", desc = "Show Available Keymaps" },
      {
        "<leader>/",
        function()
          require("telescope.builtin").live_grep {
            default_text = vim.fn.expand "<cword>",
          }
        end,
        desc = "Grep in Files (cwd)",
      },
      {
        "<leader>sg",
        function()
          require("telescope.builtin").live_grep {
            default_text = vim.fn.expand "<cword>",
            cwd = vim.lsp.buf.list_workspace_folders()[1] or "",
            prompt_title = "Live Grep (Root dir)",
          }
        end,
        desc = "Grep in Files (root)",
      },
      {
        "<leader>pr",
        function()
          require("telescope").load_extension "refactoring"
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = "v",
        desc = "Refactoring",
      },
      { "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "Show Open Buffers" },
      { "<leader>ht", "<cmd>Telescope help_tags<cr>", desc = "Telescope Help Tags" },
      { "<leader>bc", "<cmd>Telescope git_bcommits<CR>", desc = "Telescope Buffer Git Commits" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Telescope Git Commits" },
      { "gs", "<cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
      {
        "<leader>tm",
        function()
          require("telescope.builtin").man_pages { sections = { "ALL" } }
        end,
        desc = "Search Through man pages",
      },
    },
    config = function()
      local telescope = require "telescope"
      telescope.setup {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          multi_icon = "",
          sorting_strategy = "ascending",
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
          },
        },
      }
      telescope.load_extension "fzf"
      telescope.load_extension "git_worktree"
    end,
  },
  {
    "aretrosen/oil.nvim",
    cmd = "Oil",
    keys = {
      {
        "<F2>",
        function()
          require("oil").toggle_float()
        end,
        desc = "Oil File Explorer (cwd)",
      },
    },
    opts = {
      columns = {
        "icon",
      },
      delete_to_trash = true,
      trash_command = "trash-put",
      skip_confirm_for_simple_edits = true,
      float = {
        padding = 0,
        max_width = 40,
        anchor = "NE",
        row = 0,
        col = function()
          return vim.o.columns
        end,
        zindex = 1200,
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local dontshow = { "node_modules" }
          return vim.tbl_contains(dontshow, name)
        end,
      },
    },
  },
}
