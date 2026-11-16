-- Picker (files, grep, LSP symbols), vim.ui.select and indent guides.
-- Replaces telescope (+ fzf-native, ui-select) and indent-blankline.
local function pick(name)
  return function() Snacks.picker[name]() end
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false, -- it asks not to be lazy-loaded
  opts = {
    picker = { enabled = true },
    indent = { enabled = true, animate = { enabled = false } },
  },
  keys = {
    { '<leader>?',       pick('recent'),      desc = '[?] Find recently opened files' },
    { '<leader><space>', pick('buffers'),     desc = '[ ] Find existing buffers' },
    { '<leader>gf',      pick('git_files'),   desc = 'Search [G]it [F]iles' },
    { '<leader>sf',      pick('files'),       desc = '[S]earch [F]iles' },
    { '<leader>sh',      pick('help'),        desc = '[S]earch [H]elp' },
    { '<leader>sw',      pick('grep_word'),   desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader>sg',      pick('grep'),        desc = '[S]earch by [G]rep' },
    { '<leader>sd',      pick('diagnostics'), desc = '[S]earch [D]iagnostics' },
  },
}
