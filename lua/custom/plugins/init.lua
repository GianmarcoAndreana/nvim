-- You can add your own plugins here or in other files in this directory!
-- I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  -- Latex support
  {
    'lervag/vimtex',
    ft = { 'tex', 'plaintex', 'latex' }, -- load only for TeX files
    init = function()
      -- No options set: VimTeX defaults already use latexmk and (on Windows) SumatraPDF.
      -- Kickstart already defines <localleader> = "\\", which VimTeX uses.
      --#endregion
      -- explicitly use latexmk as the compiler
      vim.g.vimtex_compiler_method = 'latexmk'
      --quickfix settings
      vim.g.vimtex_quickfix_open_on_warning = 0 --  don't open quickfix if there are only warnings
      vim.g.vimtex_quickfix_ignore_filters =
        { 'Underfull', 'Overfull', 'LaTeX Warning: .\\+ float specifier changed to', 'Package hyperref Warning: Token not allowed in a PDF string' }
    end,
  },
  -- REPL
  {
    'hkupty/iron.nvim',
    config = function(plugins, opts)
      local iron = require 'iron.core'

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            python = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { 'python' },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').right(60),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = '<space>rc',
          visual_send = '<space>rc',
          send_file = '<space>rf',
          send_line = '<space>rl',
          send_mark = '<space>rm',
          mark_motion = '<space>rmc',
          mark_visual = '<space>rmc',
          remove_mark = '<space>rmd',
          cr = '<space>r<cr>',
          interrupt = '<space>r<space>',
          exit = '<space>rq',
          clear = '<space>rx',
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
      vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
      vim.keymap.set('n', '<space>rF', '<cmd>IronFocus<cr>')
      vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
    end,
  },
}
