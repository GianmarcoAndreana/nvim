-- lua/plugins/dap-python.lua
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'mfussenegger/nvim-dap-python',
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio', -- dap-ui dependency
    'theHamsta/nvim-dap-virtual-text', -- optional, inline values
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Use the nearest .venv (created by uv) if present
    local function get_python()
      local sep = package.config:sub(1, 1)
      local venv = vim.fs.find({ '.venv', 'venv' }, { upward = true, type = 'directory' })[1]
      if venv then
        return sep == '\\' and (venv .. '\\Scripts\\python.exe') or (venv .. '/bin/python')
      end
      return (vim.fn.exepath 'python3' ~= '' and 'python3') or 'python'
    end
    local python = get_python()

    -- nvim-dap-python sets up debugpy adapter + handy test helpers
    require('dap-python').setup(python, { include_configs = true })

    -- UI + virtual text
    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    dap.listeners.after.event_initialized['dapui'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui'] = function()
      dapui.close()
    end

    -- Signs
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticOk', linehl = 'Visual' })

    -- Keymaps
    local map = vim.keymap.set
    map('n', '<Leader>dc', function()
      dap.continue()
    end, { desc = 'DAP Continue/Start' })
    --    map('n', '<F10>', function() dap.step_over() end,              { desc = 'DAP Step Over' })
    --    map('n', '<F11>', function() dap.step_into() end,              { desc = 'DAP Step Into' })
    --    map('n', '<F12>', function() dap.step_out() end,               { desc = 'DAP Step Out' })
    map('n', '<Leader>db', function()
      dap.toggle_breakpoint()
    end, { desc = 'DAP Toggle Breakpoint' })
    map('n', '<Leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'DAP Conditional Breakpoint' })
    map('n', '<Leader>dr', function()
      dap.repl.toggle()
    end, { desc = 'DAP REPL' })
    map('n', '<Leader>dl', function()
      dap.run_last()
    end, { desc = 'DAP Run Last' })

    -- Python test helpers (via nvim-dap-python)
    map('n', '<Leader>tm', function()
      require('dap-python').test_method()
    end, { desc = 'Debug test method' })
    map('n', '<Leader>tc', function()
      require('dap-python').test_class()
    end, { desc = 'Debug test class' })
    map('v', '<Leader>ts', function()
      require('dap-python').debug_selection()
    end, { desc = 'Debug selection' })

    -- Useful default configurations
    dap.configurations.python = dap.configurations.python or {}
    table.insert(dap.configurations.python, 1, {
      type = 'python',
      request = 'launch',
      name = 'Python: Launch current file',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      justMyCode = true,
      pythonPath = function()
        return get_python()
      end, -- ensure per-project interpreter
    })
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'attach',
      name = 'Python: Attach (localhost:5678)',
      connect = { host = '127.0.0.1', port = 5678 },
      justMyCode = false,
    })

    -- Optional: if you switch projects in the same nvim session, keep adapter in sync
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = function()
        require('dap-python').setup(get_python())
      end,
    })
  end,
}
