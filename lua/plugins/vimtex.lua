return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_general_viewer = 'SumatraPDF'
    vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
  end,
}
