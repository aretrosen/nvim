local grp = vim.api.nvim_create_augroup("Essential", { clear = true })
local au = vim.api.nvim_create_autocmd

au({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime", group = grp })

au("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      require("osc52").copy_register "+"
    end
    vim.highlight.on_yank { timeout = 500 }
  end,
  group = grp,
})

au("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, [["]])
    local lines = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lines then
      vim.F.npcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = grp,
})

au("BufWritePre", {
  group = grp,
  callback = function(ctx)
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    if dir:find "%l+://" ~= 1 and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

au("TermOpen", {
  command = "setlocal listchars= nonumber norelativenumber | startinsert",
  group = grp,
})

au("FileType", {
  pattern = { "qf", "help", "man", "lspinfo", "tsplayground", "notify", "checkhealth" },
  group = grp,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>xit<cr>", { buffer = event.buf, silent = true })
  end,
})
