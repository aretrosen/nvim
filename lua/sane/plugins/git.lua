return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    config = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Git goto next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Git goto prev hunk" })

        -- Actions
        map("n", "<leader>sh", gs.stage_hunk)
        map("n", "<leader>rh", gs.reset_hunk)
        map("n", "<leader>ph", gs.preview_hunk)
        map("v", "<leader>sh", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        map("v", "<leader>rh", function()
          gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end)
        map("n", "<leader>sb", gs.stage_buffer)
        map("n", "<leader>uh", gs.undo_stage_hunk)
        map("n", "<leader>rb", gs.reset_buffer)
      end,
    },
  },
  { "rawnly/gist.nvim", cmd = { "CreateGist", "CreateGistFromFile" } },
}
