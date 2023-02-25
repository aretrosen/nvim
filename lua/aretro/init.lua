-- Use Space as leader and localleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrapping lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

-- setting neovim options
require "aretro.options"

-- configuring lazy.nvim
require("lazy").setup("sane.plugins", {
  defaults = { lazy = true },
  diff = { cmd = "terminal_git" },
  install = { colorscheme = { "catppuccin", "habamax" } },
  dev = { path = "~/.config/nvim/lua_plugins" },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require "aretro.autocmds"
require "aretro.keymaps"
