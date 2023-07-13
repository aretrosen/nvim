local o = vim.opt

-- global options
o.autowriteall = true
o.clipboard = "unnamedplus"
o.cmdheight = 0
o.completeopt = "menu,menuone,noselect"
o.diffopt:append {
  "linematch:60",
  "algorithm:histogram",
  "indent-heuristic",
  "vertical",
}
o.fillchars = { eob = " ", fold = " " }
o.foldlevelstart = 1
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
o.ignorecase = true
o.laststatus = 3
o.listchars = {
  tab = "» ",
  eol = "↲",
  nbsp = "␣",
  lead = "␣",
  trail = "·",
  extends = "↴",
  precedes = "→",
}
o.mouse = "n"
o.mousemodel = "extend"
o.mousescroll = "ver:2,hor:4"
o.pumblend = 10
o.pumheight = 10
o.ruler = false
o.scrolloff = 15
o.sessionoptions = { "buffers", "curdir", "tabpages", "winpos", "winsize" }
o.shada = [[!,'50,<50,s100,h]]
o.shiftround = true
o.shortmess:append { W = true, I = true, c = true, C = true, o = true }
o.showbreak = "↪ "
o.showmode = false
o.sidescrolloff = 5
o.smartcase = true
o.splitbelow = true
o.splitkeep = "screen"
o.splitright = true
o.switchbuf = "useopen"
o.termguicolors = true
o.timeoutlen = 350
o.ttimeoutlen = 20
o.updatetime = 150
o.virtualedit = "block"
o.wildmode = "longest:full,full"
o.winminwidth = 5

-- buffer options
o.expandtab = true
o.formatoptions = "tcrqnljp"
o.infercase = true
o.shiftwidth = 2
o.smartindent = true
o.softtabstop = 2
o.spelllang = { "en_us" }
o.spelloptions = "camel"
o.tabstop = 2
o.textwidth = 80
o.undofile = true

-- window options
o.breakindentopt:append { "min:20", "shift:2" }
o.colorcolumn = "+1"
o.cursorline = true
o.foldnestmax = 5
o.foldmethod = "indent"
o.linebreak = true
o.list = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.wrap = true
-- statuscolumn

-- custom decorations
_G.custom_foldtext = function()
  local line_cnt = vim.v.foldend - vim.v.foldstart + 1
  local start_part = vim.v.folddashes .. vim.fn.getline(vim.v.foldstart) .. " "
  local end_part = " "
    .. tostring(line_cnt)
    .. " lines:"
    .. string.format("%6.1f", (line_cnt / vim.api.nvim_buf_line_count(0)) * 100)
    .. "% .."
  local width = vim.go.columns - vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff
  start_part = start_part:sub(1, width - #end_part - 2)
  local mid_part = string.rep(".", width - #end_part - #start_part)
  return start_part .. mid_part .. end_part
end

o.foldtext = "v:lua.custom_foldtext()"
