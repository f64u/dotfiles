return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    -- NOTE: repo moved from williamboman/ to mason-org/ (v2). `ensure_installed`
    -- was dropped here because mason.nvim has no such option (that belongs to
    -- mason-lspconfig / mason-tool-installer) -- it was silently doing nothing,
    -- and tinymist comes from the nix package set anyway.
    { 'mason-org/mason.nvim', opts = {} },

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', opts = {}, event = 'LspAttach' },

    -- Lua LS support for the Neovim API. Replaces neodev.nvim, archived 2024-07.
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },

    { 'saghen/blink.cmp' },
  },

  config = function()
    require('custom.configs.autoformat').setup()
  end
}
