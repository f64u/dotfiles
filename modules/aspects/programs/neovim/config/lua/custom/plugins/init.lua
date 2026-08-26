return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {}, event = 'VeryLazy' },

  -- <Ctrl-DIRECTION> and better tmux integration
  'christoomey/vim-tmux-navigator',

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
        globalstatus = true,
      },

    },
  },

  -- NOTE: "gc" to comment visual regions/lines is built into Neovim now
  -- (:h commenting), so Comment.nvim was dropped.

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- `master` is locked to Nvim 0.11 and breaks on 0.12
    lazy = false, -- the rewrite does not support lazy-loading
    build = ':TSUpdate',
  },

  {
    -- Auto pair text objects
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}
  },

  {
    -- Easier mainpulation (add/remove/change) of pairs
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {}
  },

  -- Latex
  {
    'lervag/vimtex',
    -- not ft='latex' because the plugin itself offers the ft
    lazy = false,
    init = function()
      vim.g.conceal_level = 2
      vim.g.vimtex_view_method = 'skim'
    end
  },

  -- Better vim.ui.select. Replaces dressing.nvim (archived 2025-02), reusing
  -- the telescope UI already configured rather than pulling in a new framework.
  {
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    config = function()
      require('telescope').load_extension 'ui-select'
    end,
  },

  {
    -- Better undoing experience
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Toggle undotree' },
    }
  },

  -- Icons in nvim tabs
  { 'alvarosevilla95/luatab.nvim', opts = {} },

  -- Highlight todo
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = {
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      }
    }
  }
}
