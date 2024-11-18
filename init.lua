-- Faster loading time
if vim.loader then
	vim.loader.enable()
end

-- Use space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
