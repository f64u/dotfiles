return {
  'mrcjkb/rustaceanvim',
  version = '^9',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('custom.util.lspconfig').on_attach
      }
    }
  end
}
