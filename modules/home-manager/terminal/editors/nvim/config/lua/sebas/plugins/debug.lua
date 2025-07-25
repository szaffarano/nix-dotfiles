return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',

    -- language-specific debuggers configurations
    {
      'leoluz/nvim-dap-go',
      config = function()
        require('dap-go').setup()
      end,
    },
    {
      'mfussenegger/nvim-dap-python',
      config = function()
        require('dap-python').setup 'uv'
      end,
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_virtual_text = require 'nvim-dap-virtual-text'

    vim.keymap.set('n', '<F9>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<S-F9>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<S-F8>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    vim.keymap.set('n', '<Leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
    vim.keymap.set('n', '<Leader>df', function()
      ---@diagnostic disable-next-line: missing-fields
      require('dapui').float_element('scopes', { enter = true })
    end, { desc = 'Debug: Describe scope' })

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {}
    dap_virtual_text.setup {}

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '-i', 'dap' },
    }

    dap.adapters.codelldb = {
      type = 'executable',
      command = 'codelldb',
    }

    dap.configurations.asm = {
      {
        name = 'Launch',
        type = 'gdb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
        stopAtBeginningOfMainSubprogram = true,
      },
    }

    dap.configurations.c = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

    dap.configurations.cpp = dap.configurations.c

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'SignColumn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'SignColumn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '×', texthl = 'SignColumn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '▶', texthl = 'SignColumn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '→', texthl = 'SignColumn', linehl = 'debugPC', numhl = '' })
  end,
}
