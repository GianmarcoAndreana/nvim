return {
  'Vigemus/iron.nvim',
  ft = { 'python' }, -- Only load when editing Python files
  config = function()
    local iron = require 'iron.core'
    local view = require 'iron.view'

    iron.setup {
      config = {
        repl_open_cmd = view.split.vertical.botright(80), -- Open REPL in a vertical split
        repl_definition = {
          python = {
            command = { 'ipython', '--no-autoindent' },
            format = require('iron.fts.common').bracketed_paste,
          }, -- Add other language REPLs here if needed
        },
      },
      keymaps = {
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sa',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>rq<space>',
        exit = '<space>sq',
        clear = '<space>cl',
      },
      highlight = { italic = true },
      ignore_blank_lines = true,
    }

    -- Keymap to start the REPL
    vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>', { desc = 'Start REPL' })
    -- Keymap to quit the REPL
    vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>', { desc = 'Restart REPL' })
  end,
}
