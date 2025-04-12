return {
  'stevearc/oil.nvim',
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
    -- Or use this one if you prefer icons from web-devicons:
    -- "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  opts = {}, -- this is equivalent to require("oil").setup({})
}
