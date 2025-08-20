return {
  {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'willothy/wezterm.nvim', -- needed for WezTerm image support
    },
    init = function()
      -- molten core config (set globals here)
      vim.g.molten_auto_open_output = false -- required when using wezterm
      vim.g.molten_output_show_more = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_split_direction = 'right'
      vim.g.molten_split_size = 40
      vim.g.molten_virt_text_output = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_image_popup = false
      vim.g.molten_output_win_zindex = 50

      -- tell molten to use wezterm for images
      vim.g.molten_image_provider = 'wezterm'
    end,
    config = function()
      -- Keymaps for molten-nvim
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Run the current line
      map('n', '<leader>rl', ':MoltenEvaluateLine<CR>', opts)

      -- Run the current cell
      map('n', '<leader>rc', ':MoltenReevaluateCell<CR>', opts)

      -- Run visual selection
      map('v', '<leader>r', ':<C-u>MoltenEvaluateVisual<CR>', opts)

      -- Run entire buffer
      map('n', '<leader>ra', ':MoltenReevaluateAll<CR>', opts)

      -- Show/hide output window
      map('n', '<leader>ro', ':MoltenShowOutput<CR>', opts)
      map('n', '<leader>rh', ':MoltenHideOutput<CR>', opts)

      -- Restart kernel
      map('n', '<leader>rr', ':MoltenRestart<CR>', opts)

      -- Go to next/previous cell
      map('n', '<leader>rn', ':MoltenNext<CR>', opts)
      map('n', '<leader>rp', ':MoltenPrev<CR>', opts)

      -- Export output (HTML/Markdown)
      map('n', '<leader>re', ':MoltenExportOutput<CR>', opts)

      -- Extra: open plots in popup (if not using wezterm)
      map('n', '<leader>ri', ':MoltenImagePopup<CR>', opts)
    end,
  },
}
