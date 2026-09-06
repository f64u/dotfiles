return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- NOTE: no mason.nvim. Every server in custom/configs/lsp.lua now comes
    -- from the nix package set (see ../../../default.nix), so servers are
    -- declared in one place and work identically on darwin and NixOS --
    -- mason's downloaded binaries would not run on the latter.
    --
    -- ~/.local/share/nvim/mason/ is now orphaned and can be deleted.

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
