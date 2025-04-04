return {
  'Vigemus/iron.nvim',
  config = function()
    local iron = require 'iron.core'
    local view = require 'iron.view'

    iron.setup {
      config = {
        -- Define how the REPL window will be displayed
        repl_open_cmd = view.split.vertical.botright(80),
        -- Define REPL configurations for specific file types
        repl_definition = {
          python = {
            -- Can be a table or a function that returns a table
            command = { 'ipython', '--no-autoindent' },
          },
          -- Add other languages here
        },
        -- Other configurations can be added here
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps later.
      keymaps = {
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sf',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>s<space>',
        exit = '<space>sq',
        clear = '<space>cl',
      },
      -- Highlighting settings
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }
    -- Keymap to start the REPL
    vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>', { desc = 'Start REPL' })
  end,
}
