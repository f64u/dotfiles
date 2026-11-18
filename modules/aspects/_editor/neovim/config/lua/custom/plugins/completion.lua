return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    -- v2 hard-errors at require time without this
    'saghen/blink.lib',
  },
  -- v2 builds through the plugin.
  build = function()
    require('blink.cmp').build():pwait()
  end,
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    signature = { enabled = true }
  },
  opts_extend = { 'sources.default' }
}
