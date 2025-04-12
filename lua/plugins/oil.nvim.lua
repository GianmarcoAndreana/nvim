return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
    -- Or use this one if you prefer icons from web-devicons:
    -- "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require('oil').setup {
      keymaps = {
        ['q'] = 'actions.close', -- ensure q is mapped
        ['<CR>'] = 'actions.select', -- open file/dir
        ['<C-s>'] = 'actions.select_split', -- split
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-t>'] = 'actions.select_tab',
        ['-'] = 'actions.parent', -- go up
        ['~'] = 'actions.open_cwd', -- go to cwd
        ['gs'] = 'actions.change_sort', -- sort
        ['g?'] = 'actions.show_help',
      },
    }

    -- Global keymap to open Oil
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open Oil directory view' })
  end,
}
