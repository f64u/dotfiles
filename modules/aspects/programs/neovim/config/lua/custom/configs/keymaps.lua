-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Easy terminal escape
vim.keymap.set('t', '<C-x>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
  { desc = 'Escape terminal mode' })

-- NOTE: `[d` / `]d` are Neovim defaults and are deliberately not remapped
-- here. The old versions hardcoded `count = ±1` (so `3]d` did not work) and
-- passed `float`, which is deprecated in 0.12 and printed a warning on every
-- jump. The float-on-jump behaviour is now set globally in configs/lsp.lua.
-- `<C-W>d` is the built-in for showing the diagnostic under the cursor.
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- stolen from primagean
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- NOTE: `bn`/`bp`/`bd` used to be mapped here, which made every bare `b`
-- (back-a-word) wait out 'timeoutlen'. `[b` / `]b` (and `[B` / `]B` for
-- first/last) are Neovim defaults, so only the delete needs a map.
vim.keymap.set('n', '<leader>bd', ':bd<cr>', { desc = '[B]uffer [D]elete', silent = true })
