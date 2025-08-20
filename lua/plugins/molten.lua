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
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      -- tell molten to use wezterm for images
      vim.g.molten_image_provider = 'wezterm'
    end,
    config = function()
      -- Keymaps for molten-nvim
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, desc = 'Molten' }

      -- Initialize Molten (required before running code)
      map('n', '<leader>mi', ':MoltenInit<CR>', vim.tbl_extend('force', opts, { desc = 'Initialize Molten' }))

      -- Run operations
      map('n', '<leader>rl', ':MoltenEvaluateLine<CR>', vim.tbl_extend('force', opts, { desc = 'Evaluate line' }))
      map('n', '<leader>rc', ':MoltenReevaluateCell<CR>', vim.tbl_extend('force', opts, { desc = 'Re-evaluate cell' }))
      map('v', '<leader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', vim.tbl_extend('force', opts, { desc = 'Evaluate visual selection' }))
      map('n', '<leader>ro', ':MoltenEvaluateOperator<CR>', vim.tbl_extend('force', opts, { desc = 'Evaluate operator' }))

      -- Cell operations
      map('n', '<leader>rd', ':MoltenDelete<CR>', vim.tbl_extend('force', opts, { desc = 'Delete cell' }))
      map('n', '<leader>rn', ':MoltenNext<CR>', vim.tbl_extend('force', opts, { desc = 'Next cell' }))
      map('n', '<leader>rp', ':MoltenPrev<CR>', vim.tbl_extend('force', opts, { desc = 'Previous cell' }))

      -- Output operations
      map('n', '<leader>oh', ':MoltenHideOutput<CR>', vim.tbl_extend('force', opts, { desc = 'Hide output' }))
      map('n', '<leader>os', ':noautocmd MoltenEnterOutput<CR>', vim.tbl_extend('force', opts, { desc = 'Show/enter output' }))

      -- Kernel operations
      map('n', '<leader>rr', ':MoltenRestart!<CR>', vim.tbl_extend('force', opts, { desc = 'Restart kernel (force)' }))
      map('n', '<leader>ri', ':MoltenInterrupt<CR>', vim.tbl_extend('force', opts, { desc = 'Interrupt execution' }))

      -- Info and status
      map('n', '<leader>rs', ':MoltenInfo<CR>', vim.tbl_extend('force', opts, { desc = 'Show Molten info' }))

      -- Export operations
      map('n', '<leader>re', ':MoltenExportOutput!<CR>', vim.tbl_extend('force', opts, { desc = 'Export output' }))

      -- Save/Load operations
      map('n', '<leader>ms', ':MoltenSave<CR>', vim.tbl_extend('force', opts, { desc = 'Save session' }))
      map('n', '<leader>ml', ':MoltenLoad<CR>', vim.tbl_extend('force', opts, { desc = 'Load session' }))

      -- Image popup (when not auto-showing)
      map('n', '<leader>ip', ':MoltenImagePopup<CR>', vim.tbl_extend('force', opts, { desc = 'Open image popup' }))

      -- Optional: Define text objects for cells
      map({ 'x', 'o' }, 'ih', ':<C-u>MoltenOperator<CR>', vim.tbl_extend('force', opts, { desc = 'Molten text object' }))
    end,
  },
}
