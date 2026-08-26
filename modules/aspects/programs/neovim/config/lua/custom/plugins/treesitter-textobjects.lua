-- Syntax-aware text objects. The `main` branch is a rewrite: there is no
-- `textobjects = { select = { keymaps = ... } }` block any more, so the
-- keymaps are set explicitly against the new API.
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
      },
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'
    local swap = require 'nvim-treesitter-textobjects.swap'

    -- select
    for key, obj in pairs {
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    } do
      vim.keymap.set({ 'x', 'o' }, key, function() select.select_textobject(obj, 'textobjects') end)
    end

    -- move
    for key, spec in pairs {
      [']m'] = { move.goto_next_start, '@function.outer' },
      [']]'] = { move.goto_next_start, '@class.outer' },
      [']M'] = { move.goto_next_end, '@function.outer' },
      [']['] = { move.goto_next_end, '@class.outer' },
      ['[m'] = { move.goto_previous_start, '@function.outer' },
      ['[['] = { move.goto_previous_start, '@class.outer' },
      ['[M'] = { move.goto_previous_end, '@function.outer' },
      ['[]'] = { move.goto_previous_end, '@class.outer' },
    } do
      vim.keymap.set({ 'n', 'x', 'o' }, key, function() spec[1](spec[2], 'textobjects') end)
    end

    -- swap
    vim.keymap.set('n', '<leader>a', function() swap.swap_next '@parameter.inner' end)
    vim.keymap.set('n', '<leader>A', function() swap.swap_previous '@parameter.inner' end)
  end,
}
