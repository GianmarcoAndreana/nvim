return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 10 -- Height for horizontal terminal
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4 -- Width for vertical terminal
        end
      end,
      -- open_mapping = [[<C-\>]], -- Press Ctrl+\ to toggle
      shade_terminals = true, -- Dim background for better visibility
      direction = 'float', -- Ensure terminal opens in floating mode
      close_on_exit = true, -- Auto close when terminal exits
      shell = '"C:\\Program Files\\WezTerm\\wezterm.exe"', -- Set WezTerm as default shell
    }

    -- Floating Terminal with a Specific Shell (e.g., PowerShell)
    local Terminal = require('toggleterm.terminal').Terminal
    local floating_term = Terminal:new { cmd = 'pwsh', hidden = true, direction = 'float' }

    -- Toggle Floating Terminal with <leader>t
    vim.keymap.set('n', '<C-\\>', function()
      floating_term:toggle()
    end, { desc = 'Toggle Floating Terminal' })
  end,
}
