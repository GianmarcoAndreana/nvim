return {
  'Vigemus/iron.nvim',
  ft = { 'python' }, -- load only for Python buffers
  config = function()
    local iron = require 'iron.core'
    local view = require 'iron.view'

    iron.setup {
      config = {
        scratch_repl = true, -- don't litter buffers
        repl_open_cmd = view.split.vertical.botright(80), -- vertical split on the right
        repl_definition = {
          python = {
            command = { 'ipython', '--no-autoindent' },
            format = require('iron.fts.common').bracketed_paste,
          },
        },
      },
      keymaps = {
        -- Keep things simple: one "send" key that works in normal and visual
        send_line = '<leader>rs', -- normal: send current line
        visual_send = '<leader>rs', -- visual: send selection
        send_motion = '<leader>rm', -- operator-pending: <leader>rmip, etc.
        send_file = '<leader>ra',
        send_paragraph = '<leader>rp',
        send_until_cursor = '<leader>ru',
        interrupt = '<leader>ri',
        exit = '<leader>rq',
        clear = '<leader>rc',
      },
      highlight = { italic = true },
      ignore_blank_lines = true,
    }

    -- Toggle REPL (open if not present, otherwise close)
    vim.g.__iron_python_repl_open = false
    local function toggle_repl()
      -- Try to detect an ipython terminal in the current tab
      local found = false
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_loaded(buf) then
          local bt = vim.bo[buf].buftype
          local name = vim.api.nvim_buf_get_name(buf)
          if bt == 'terminal' and name:match 'ipython' then
            found = true
            break
          end
        end
      end
      if found or vim.g.__iron_python_repl_open then
        vim.cmd 'IronClose'
        vim.g.__iron_python_repl_open = false
      else
        vim.cmd 'IronRepl'
        vim.g.__iron_python_repl_open = true
      end
    end

    -- Keymaps for toggling/focusing/restarting the REPL
    vim.keymap.set('n', '<leader>rt', toggle_repl, { desc = 'REPL: toggle (open/close)' })
    vim.keymap.set('n', '<leader>rf', function()
      pcall(vim.cmd, 'IronFocus') -- focus REPL if open
    end, { desc = 'REPL: focus' })
    vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<CR>', { desc = 'REPL: restart' })

    -- Keep the toggle flag in sync if the terminal closes by other means
    vim.api.nvim_create_autocmd({ 'TermClose', 'BufWipeout' }, {
      group = vim.api.nvim_create_augroup('IronReplToggle', { clear = true }),
      pattern = { 'term://*ipython*', 'term://*/ipython', 'term://*python*' },
      callback = function()
        vim.g.__iron_python_repl_open = false
      end,
      desc = 'Reset REPL toggle flag when terminal closes',
    })
  end,
}
