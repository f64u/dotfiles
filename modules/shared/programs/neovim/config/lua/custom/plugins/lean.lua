return {
  -- Lean proofing helper
  'Julian/lean.nvim',
  ft = 'lean',
  opts = {
    lsp = {
      on_attach = require('custom.util.lspconfig').on_attach,
    },
    mappings = true,
    infoview = {
      width = 50,
    },
  },
}
