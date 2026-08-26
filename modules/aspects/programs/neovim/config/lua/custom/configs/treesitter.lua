-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
--
-- NOTE: targets nvim-treesitter's `main` branch, which is a full rewrite:
-- `require('nvim-treesitter.configs').setup{}` is gone. Parsers are installed
-- explicitly, and highlight/indent come from Neovim's built-in treesitter.
-- The old `master` branch is locked to Neovim 0.11 and breaks on 0.12.

-- Single source of truth: parser names. `latex` is deliberately absent, as it
-- was in `highlight.disable`, so it keeps plain vim syntax.
local languages = {
  'c',
  'cpp',
  'go',
  'lua',
  'python',
  'rust',
  'tsx',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  -- needed for LSP hover docs, which blink.cmp renders as markdown
  'markdown',
  'markdown_inline',
}

-- Nvim knows help/checkhealth -> vimdoc, but nothing maps tsx -> typescriptreact.
vim.treesitter.language.register('tsx', 'typescriptreact')

-- No-op for parsers that are already installed.
require('nvim-treesitter').install(languages)

-- Derive filetypes from the parser list rather than repeating it.
local filetypes = {}
for _, lang in ipairs(languages) do
  vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true }),
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- was `additional_vim_regex_highlighting = { 'markdown' }`
    if vim.bo.filetype == 'markdown' then vim.bo.syntax = 'on' end
  end,
})

-- NOTE: `incremental_selection` is gone from nvim-treesitter because Nvim 0.12
-- ships it: `an`/`in` select the parent/child node, `]n`/`[n` the next/previous,
-- `]N`/`[N` expand the selection. See `:h treesitter-incremental-selection`.
-- The old <c-space>/<c-bs>/<M-space> maps no longer exist.

-- vim: ts=2 sts=2 sw=2 et
