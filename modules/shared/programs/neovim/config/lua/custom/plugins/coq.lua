return {
  ft = 'coq',
  'whonore/Coqtail',
  dependencies = {
    {
      'tomtomjhj/coq-lsp.nvim',
      opts = {
        lsp = {
          on_attach = require('custom.util.lspconfig').on_attach,
          autostart = true
        }
      }
    }
  }
}
