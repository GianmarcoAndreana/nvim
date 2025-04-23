return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    -- Set viewer for forward search
    vim.g.vimtex_view_general_viewer = 'SumatraPDF'
    vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]

    -- Automatically close quickfix after using `\ll`
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1

    -- Optional: Define a command for manual cleaning
    vim.api.nvim_create_user_command('LatexClean', function()
      vim.fn.jobstart({ 'latexmk', '-c' }, { cwd = vim.fn.expand '%:p:h' })
    end, { desc = 'Clean LaTeX build files with latexmk -c' })

    -- Auto clean auxiliary files on buffer leave (closing .tex files)
    vim.api.nvim_create_autocmd('BufWinLeave', {
      pattern = '*.tex',
      callback = function()
        vim.fn.jobstart({ 'latexmk', '-c' }, { cwd = vim.fn.expand '%:p:h' })
      end,
    })
  end,
}
