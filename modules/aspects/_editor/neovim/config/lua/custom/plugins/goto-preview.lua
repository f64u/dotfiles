return {
  'rmagatti/goto-preview',
  dependencies = { 'rmagatti/logger.nvim' },
  -- The plugin only binds these keys.
  keys = { 'gpd', 'gpt', 'gpi', 'gpD', 'gpr', 'gP' },
  opts = {
    default_mappings = true,
  },
}
