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
  -- GitHub Copilot
  {
    'github/copilot.vim',
  },
}
