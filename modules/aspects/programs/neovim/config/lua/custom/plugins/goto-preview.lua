return {
  'rmagatti/goto-preview',
  dependencies = { 'rmagatti/logger.nvim' },
  -- `event = 'BufEnter'` fired on the very first buffer, i.e. eager loading
  -- with extra bookkeeping. The plugin only binds these keys.
  keys = { 'gpd', 'gpt', 'gpi', 'gpD', 'gpr', 'gP' },
  opts = {
    default_mappings = true,
  },
}
