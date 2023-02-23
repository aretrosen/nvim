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
    },
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<F2>",
        function()
          require("neo-tree.command").execute {
            toggle = true,
          }
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "neo-tree"
        end
      end
    end,
    opts = {
      close_if_last_window = true,
      name = { trailing_slash = true },
      source_selector = {
        winbar = true,
      },
      filesystem = {
        components = {
          harpoon_index = function(config, node, _)
            local Marked = require "harpoon.mark"
            local path = node:get_id()
            local succuss, index = pcall(Marked.get_index_of, path)
            if succuss and index and index > 0 then
              return {
                text = string.format(" ⥤ %d", index),
                highlight = config.highlight or "NeoTreeDirectoryIcon",
              }
            else
              return {}
            end
          end,
        },
        renderers = {
          file = {
            { "icon" },
            { "name", use_git_status_colors = true },
            { "harpoon_index" },
            { "diagnostics" },
            { "git_status", highlight = "NeoTreeDimText" },
          },
        },
        bind_to_cwd = true,
        cwd_target = {
          sidebar = "tab",
          current = "window",
        },
        follow_current_file = true,
      },
    },
  },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-project.nvim" },
  { "ThePrimeagen/git-worktree.nvim" },
  { "smartpde/telescope-recent-files" },
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
      { "<leader>km", "<cmd>Telescope keymaps<cr>", desc = "Show Available Keymaps" },
      { "<leader>tc", "<cmd>Telescope commands<cr>", desc = "Show Available Commands" },
      { "<leader>vo", "<cmd>Telescope vim_options<cr>", desc = "Vim Options" },
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
      { "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "Show Open Buffers" },
      { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Telescope Help Tags" },
      { "<leader>bc", "<cmd>Telescope git_bcommits<CR>", desc = "Telescope Buffer Git Commits" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Telescope Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Telescope Git status" },
      {
        "<leader>sM",
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
}
