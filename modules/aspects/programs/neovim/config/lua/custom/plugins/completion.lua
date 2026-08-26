return {
  'saghen/blink.cmp',
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = {
    'rafamadriz/friendly-snippets',
    -- v2 hard-errors at require time without this
    'saghen/blink.lib',
  },
  -- v2 builds through the plugin rather than cargo directly; the rust
  -- library now lands in lib/ instead of target/release/
  build = function()
    require('blink.cmp').build():pwait()
  end,
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      -- `use_nvim_cmp_as_default` is gone: catppuccin's `blink_cmp`
      -- integration (see theme.lua) defines the highlights directly.
      nerd_font_variant = 'mono'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    signature = { enabled = true }
  },
  opts_extend = { 'sources.default' }
}
