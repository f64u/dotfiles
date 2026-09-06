return {
  {
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

      -- NOTE: mason.nvim / mason-nvim-dap.nvim used to be here to fetch
      -- debugpy. They are gone: debug adapters come from the nix package set
      -- (see ../../../default.nix), which also means they work on NixOS,
      -- where mason's downloaded binaries would not run.
      'theHamsta/nvim-dap-virtual-text',

      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('nvim-dap-virtual-text').setup()

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- C/C++/Rust debugging via lldb-dap. Resolved from PATH rather than
      -- hardcoded: this was `/opt/homebrew/opt/llvm@12/bin/lldb-vscode`, a
      -- path that is both Homebrew-only and named after a binary LLVM renamed
      -- to `lldb-dap` in LLVM 18.
      local lldb_dap = vim.fn.exepath('lldb-dap')
      if lldb_dap ~= '' then
        dap.adapters.lldb = {
          type = 'executable',
          command = lldb_dap,
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
      end
    end,
  },
  {
    -- Owns the python adapter setup; nvim-dap's config above deliberately
    -- does not also call dap_python.setup().
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap'
    },
    ft = 'python',
    config = function()
      local dap_python = require('dap-python')
      dap_python.setup('uv')
      vim.keymap.set('n', '<leader>dpt', function()
        dap_python.test_method()
      end, { desc = '[D]ebug [P]ython [T]est (method)' })

      vim.keymap.set('n', '<leader>dpc', function()
        dap_python.test_class()
      end, { desc = '[D]ebug [P]ython [C]lass' })
    end
  },
}
