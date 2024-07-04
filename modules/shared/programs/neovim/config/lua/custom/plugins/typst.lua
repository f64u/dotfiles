return {
  {
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false,
    init = function()
      vim.g.typst_syntax_highlight = 0
      vim.g.typst_conceal_emoji = true
      vim.g.typst_pdf_viewer = 'mupdf'
    end
  },
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '0.3.*',
    build = function() require 'typst-preview'.update() end,
  }
}
