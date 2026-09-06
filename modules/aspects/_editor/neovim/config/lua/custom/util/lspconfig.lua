local M = {}

--  This function gets run when an LSP connects to a particular buffer. Needs
--  to be passed to some plugins.
--
--  NOTE: most of what used to live here is now redundant. Neovim 0.11+ sets
--  these unconditionally (see `:h lsp-defaults`):
--
--    grn  rename          gra  code action     grr  references
--    gri  implementation  grt  type definition grx  run codelens
--    gO   document symbol <C-S> signature help (insert/select)
--    K    hover           gq   format (via 'formatexpr')
--
--  A bare `gr` map used to sit here, which made every one of the `gr*`
--  defaults ambiguous -- each waited out 'timeoutlen' (300ms) before firing.
--  Only the maps that genuinely add something are kept.
M.on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Telescope pickers, which are a real gain over the built-in quickfix UI.
  -- Wrapped in thunks so telescope is not force-loaded on every LspAttach.
  nmap('<leader>ds', function()
    require('telescope.builtin').lsp_document_symbols()
  end, '[D]ocument [S]ymbols')
  nmap('<leader>ws', function()
    require('telescope.builtin').lsp_dynamic_workspace_symbols()
  end, '[W]orkspace [S]ymbols')

  -- Lesser used LSP functionality
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

return M

-- vim: ts=2 sts=2 sw=2 et
