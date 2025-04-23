return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    -- Set viewer for forward search
    vim.g.vimtex_view_general_viewer = 'SumatraPDF'
    vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]

    -- Automatically close quickfix after using `\ll`
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1

    -- Automatically remove auxiliary files
    vim.api.nvim_create_user_command('LatexClean', function()
      local tex_dir = vim.fn.expand '%:p:h' -- Directory of the .tex file

      -- List of common auxiliary files to remove
      local extensions = { '.aux', '.fls', '.log', '.nav', '.out', '.toc', '.pdfsync', 'snm', '.fdb_latexmk', '.synctex' }

      for _, ext in ipairs(extensions) do
        -- Find all files with the current extension in the directory
        local files = vim.fn.glob(tex_dir .. '\\*' .. ext, false, true)

        -- Loop through the files and delete them
        for _, file in ipairs(files) do
          if vim.fn.filereadable(file) == 1 then
            vim.fn.delete(file)
            -- Suppress the message by removing the print statement
          end
        end
      end
    end, { desc = 'Manually clean LaTeX auxiliary files' })

    -- Autocmd to clean auxiliary files when closing a .tex file
    vim.api.nvim_create_autocmd('BufWinLeave', {
      pattern = '*.tex',
      callback = function()
        vim.cmd 'LatexClean' -- Call the LatexClean command
      end,
    })

    -- Autocmd to clean auxiliary files when Neovim is exited
    vim.api.nvim_create_autocmd('VimLeave', {
      callback = function()
        vim.cmd 'LatexClean' -- Call the LatexClean command
      end,
    })
  end,
}
