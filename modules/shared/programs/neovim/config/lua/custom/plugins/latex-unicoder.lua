return {
  'joom/latex-unicoder.vim',
  lazy = false,
  keys = { '<C-l>' },
  init = function()
    vim.g.unicoder_cancel_normal = 1
    vim.g.unicode_map = {
      ['\\box'] = '□',
    }
  end
}
