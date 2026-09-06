return {
  'lukas-reineke/indent-blankline.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  main = 'ibl',
  opts = {
    whitespace = { highlight = { 'Whitespace', 'NonText' } },
    scope = {
      enabled = true
    }
  }
}
