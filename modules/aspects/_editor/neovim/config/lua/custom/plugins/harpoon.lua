return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  -- Remembers the cursor position per mark.
  config = function()
    require('harpoon'):setup()
  end,

  keys = {
    {
      '<leader>ha',
      function()
        require('harpoon'):list():add()
      end,
      desc = '[H]arpoon: [A]dd current file'
    },
    {
      '<leader>hl',
      function()
        -- `require('harpoon').ui` is the instance; `harpoon.ui` is the class.
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = '[H]arpoon: Toggle quick [l]menu'
    },

    { '<A-u>', function() require('harpoon'):list():select(1) end, desc = 'Harpoon: Navigate to first file' },
    { '<A-i>', function() require('harpoon'):list():select(2) end, desc = 'Harpoon: Navigate to second file' },
    { '<A-o>', function() require('harpoon'):list():select(3) end, desc = 'Harpoon: Navigate to third file' },
    { '<A-p>', function() require('harpoon'):list():select(4) end, desc = 'Harpoon: Navigate to fourth file' },

    { '<A-[>', function() require('harpoon'):list():prev() end,    desc = 'Harpoon: Navigate to prev file in list' },
    { '<A-]>', function() require('harpoon'):list():next() end,    desc = 'Harpoon: Navigate to prev file in list' }
  }
}
