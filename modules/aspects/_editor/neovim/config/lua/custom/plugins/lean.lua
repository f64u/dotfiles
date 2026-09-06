return {
  -- Lean proofing helper
  'Julian/lean.nvim',
  ft = 'lean',
  config = function(_, opts)
    vim.lsp.config('leanls', {

      on_attach = require('custom.util.lspconfig').on_attach,
    })

    require('lean').setup(opts)
  end,
  opts = {
    mappings = true,
    infoview = {
      width = 50,
    },
  },
}
