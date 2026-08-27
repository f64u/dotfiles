return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      -- prev_hunk/next_hunk are @deprecated upstream in favour of nav_hunk.
      vim.keymap.set(
        'n',
        '<leader>gp',
        function() require('gitsigns').nav_hunk('prev') end,
        { buffer = bufnr, desc = '[G]o to [P]revious Hunk' }
      )
      vim.keymap.set(
        'n',
        '<leader>gn',
        function() require('gitsigns').nav_hunk('next') end,
        { buffer = bufnr, desc = '[G]o to [N]ext Hunk' }
      )
      vim.keymap.set(
        'n',
        '<leader>ph',
        require('gitsigns').preview_hunk,
        { buffer = bufnr, desc = '[P]review [H]unk' }
      )
    end,
  },
}
