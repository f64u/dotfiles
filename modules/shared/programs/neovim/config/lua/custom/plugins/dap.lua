return {
  'mfussenegger/nvim-dap',
  keys = {
    { '<leader>dc',  function() require('dap').continue() end,  desc = '[D]ebug: Start/[C]ontinue' },
    {
      '<leader>dq',
      function()
        require('dap').close()
        require('dapui').close() -- sometimes the event doesn't fire??
      end,
      desc = '[D]ebug: [Q]uit'
    },
    { '<leader>dsi', function() require('dap').step_into() end, desc = '[D]ebug: [S]tep [I]nto' },
    { '<leader>dso', function() require('dap').step_over() end, desc = '[D]ebug: [S]tep [o]ver' },
    { '<leader>dsO', function() require('dap').step_out() end,  desc = '[D]ebug: [S]tep [O]ut' },
    {
      '<leader>db',
      function() require('dap').toggle_breakpoint() end,
      desc =
      '[D]ebug: Toggle [b]reakpoint'
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = '[D]ebug: Set [B]reakpoint'
    },

  },
  dependencies = {
    -- Creates a beautiful debugger UI
    {
      'rcarriga/nvim-dap-ui',
      opts = {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      },
      keys = {
        { '<leader>dls', function() require('dapui').toggle() end, desc = '[D]ebug: See [l]ast [s]ession result.' },
      }
    },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',

    -- 'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',

    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        'debugpy',
        --  'delve',
      },
    }

    require('nvim-dap-virtual-text').setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- require('dap-go').setup()

    require('dap-python').setup('uv')

    -- C/C++/Rust debugging using lldb
    dap.adapters.lldb = {
      type = 'executable',
      command = '/opt/homebrew/opt/llvm@12/bin/lldb-vscode',
      name = 'lldb',
    }

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          ---@diagnostic disable-next-line: redundant-parameter
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      },
    }

    dap.configurations.c = dap.configurations.cpp
  end,
}
