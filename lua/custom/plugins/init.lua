-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'plaintex', 'latex' }, -- load only for TeX files
    init = function()
      -- No options set: VimTeX defaults already use latexmk and (on Windows) SumatraPDF.
      -- Kickstart already defines <localleader> = "\\", which VimTeX uses.
    end,
  },
}
