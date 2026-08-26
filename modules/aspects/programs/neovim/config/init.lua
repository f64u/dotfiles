-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: I need to set mapleader and maplocalleader before
-- loading lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup('custom.plugins', {
  defaults = {
    -- Skip plugins entirely when running inside vscode-neovim. This was
    -- `cond = vim.g.vscode`, i.e. exactly backwards: nil (a no-op) in plain
    -- nvim, and true -- load everything -- inside vscode.
    cond = not vim.g.vscode
  },
  -- The update check is a network round-trip on startup; `:Lazy check` is
  -- there when an update is actually wanted.
  checker = {
    enabled = false
  },
  change_detection = {
    notify = false
  },
  -- No plugin here resolves through luarocks, and the `dev` server is an
  -- unpinned moving target.
  rocks = {
    enabled = false
  },
})

require 'custom.configs'


vim.cmd [[ au VimLeave * set guicursor=a:ver20 ]]

-- vim: ts=2 sts=2 sw=2 et
--
