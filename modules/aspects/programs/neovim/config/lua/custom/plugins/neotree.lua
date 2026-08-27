return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = { 'Neotree' },
  keys = {
    { '<C-n>', '<cmd> Neotree toggle <cr>', desc = 'Toggle neotree' },
    { '<C-e>', '<cmd> Neotree focus <cr>',  desc = 'Focus neotree' },
    { '\\',    '<cmd> Neotree reveal <cr>', desc = 'Reveal neotree' }
  },

  -- NOTE: this used to carry a `config` that called vim.fn.sign_define four
  -- times to set the diagnostic icons. That API was deprecated for
  -- diagnostics in 0.10 and no longer reaches the sign column at all, so the
  -- icons now live in configs/lsp.lua's vim.diagnostic.config -- neo-tree
  -- reads `signs.text` from there, and the gutter finally gets them too.
  opts = {
    close_if_last_window = true,
    window = {
      width = 30
    }
  },
}
