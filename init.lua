-- Set global variable if env is VSCODE
if vim.env.VSCODE then
	vim.g.vscode = true
end

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
