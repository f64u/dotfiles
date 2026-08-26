-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  opts = {
    defaults = {
      mappings = {
        i = {
          -- ['<C-u>'] = false,
          -- ['<C-d>'] = false,
        },
      },
    },
    extensions = {
      fzf = {}
    },
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  keys = {
    { '<leader>?',       function() require('telescope.builtin').oldfiles() end,    desc = '[?] Find recently opened files' },
    { '<leader><space>', function() require('telescope.builtin').buffers() end,     desc = '[ ] Find existing buffers' },
    { '<leader>gf',      function() require('telescope.builtin').git_files() end,   desc = 'Search [G]it [F]iles' },
    { '<leader>sf',      function() require('telescope.builtin').find_files() end,  desc = '[S]earch [F]iles' },
    { '<leader>sh',      function() require('telescope.builtin').help_tags() end,   desc = '[S]earch [H]elp' },
    { '<leader>sw',      function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
    { '<leader>sg',      function() require('telescope.builtin').live_grep() end,   desc = '[S]earch by [G]rep' },
    { '<leader>sd',      function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
  }
}
