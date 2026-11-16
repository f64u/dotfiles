return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
  opts = {
    -- Dark follows catppuccin.flavor from Nix (set in init.lua).
    background = { light = 'latte', dark = vim.g.catppuccin_flavour or 'mocha' },
    -- transparent_background = true,
    styles = {
      comments = {},
    },
    -- Only plugins this config actually installs. The list previously also
    -- carried alpha, cmp, flash, illuminate, mason, mini, navic, neotest,
    -- noice and notify, none of which are present.
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      lsp_trouble = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
      semantic_tokens = true,
      snacks = { enabled = true },
      treesitter = true,
      which_key = true,
    },
  }
}
