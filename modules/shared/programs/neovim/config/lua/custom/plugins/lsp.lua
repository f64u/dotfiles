return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      'williamboman/mason.nvim',
      opts = {
        ensure_installed = {
          'tinymist'
        }
      }
    },

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', opts = {}, event = 'LspAttach' },

    -- Additional lua configuration, makes nvim stuff amazing!
    { 'folke/neodev.nvim', opts = {} },

    { 'saghen/blink.cmp' },
  },

  config = function()
    require('custom.configs.autoformat').setup()
  end
}
