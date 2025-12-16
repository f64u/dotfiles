return {
  'saghen/blink.cmp',
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = 'rafamadriz/friendly-snippets',
  build = 'cargo build --release', -- for delimiters
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    signature = { enabled = true }
  },
  opts_extend = { 'sources.default' }
}
