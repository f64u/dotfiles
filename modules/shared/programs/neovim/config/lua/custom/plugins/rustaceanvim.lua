return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = require('custom.util.lspconfig').on_attach
      }
    }
  end
}
