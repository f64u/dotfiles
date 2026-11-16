-- Format on save: a formatter per filetype, the language server otherwise.
-- :FormatToggle switches it off and on.
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  init = function()
    vim.api.nvim_create_user_command('FormatToggle', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      vim.notify('Format on save: ' .. (vim.g.disable_autoformat and 'off' or 'on'))
    end, {})
  end,
  opts = {
    formatters_by_ft = {
      nix = { 'nixfmt' },
      python = { 'ruff_format' },
    },
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = function()
      if vim.g.disable_autoformat then return end
      return { timeout_ms = 2000 }
    end,
  },
}
