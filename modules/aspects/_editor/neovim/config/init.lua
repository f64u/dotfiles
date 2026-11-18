-- Leader must be set before lazy loads.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("custom.plugins", {
  defaults = {
    -- Skip plugins inside vscode-neovim.
    cond = not vim.g.vscode,
  },
  -- No network check on startup; use `:Lazy check`.
  checker = {
    enabled = false,
  },
  change_detection = {
    notify = false,
  },
  -- No plugin needs luarocks.
  rocks = {
    enabled = false,
  },
})

require("custom.configs")

vim.cmd([[ au VimLeave * set guicursor=a:ver20 ]])

-- vim: ts=2 sts=2 sw=2 et
