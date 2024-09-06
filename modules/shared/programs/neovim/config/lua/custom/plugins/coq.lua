return {
  ft = 'coq',
  'whonore/Coqtail',
  dependencies = {
    {
      'tomtomjhj/vscoq.nvim',
      vscoq = {
        proof = {
          -- In manual mode, don't move the cursor when stepping forward/backward a command
          cursor = { sticky = false },
        }
      },
      opts = {
        lsp = {
          on_attach = function(client, bufnr)
            require('custom.util.lspconfig').on_attach(client, bufnr)
          end,
          autostart = false,
        }
      },
      config = function(opts)
        require('vscoq').setup(opts)
        vim.g.loaded_coqtail = 1
        vim.g['coqtail#supported'] = 0
      end
    }
  }
}
