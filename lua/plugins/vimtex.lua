return {
  {
    'lervag/vimtex',
    opts = {},
    config = function()
      -- PDF viewer settings
      vim.g.vimtex_view_general_viewer = 'SumatraPDF'
      vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
      vim.g.vimtex_view_general_options_latexmk = [[-reuse-instance -forward-search @tex @line @pdf]]

      -- Build engine settings
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      -- QuickFix settings
      vim.g.vimtex_quickfix_mode = 2 -- Open QuickFix automatically on errors, but not warnings
      vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
      vim.g.vimtex_quickfix_open_on_warning = 0 -- Don't open for warnings

      -- TOC settings
      vim.g.vimtex_toc_config = {
        mode = 1,
        fold_enable = 0,
        hide_line_numbers = 1,
        resize = 0,
        refresh_always = 1,
        show_help = 0,
        show_numbers = 1,
        split_pos = 'leftabove',
        split_width = 30,
        tocdepth = 3,
        indent_levels = 1,
      }

      -- Enhanced LatexClean command with more file types and safety check
      vim.api.nvim_create_user_command('LatexClean', function()
        local tex_dir = vim.fn.expand '%:p:h'
        -- More comprehensive list of auxiliary files
        local extensions = {
          '.aux',
          '.bbl',
          '.bcf',
          '.blg',
          '.fdb_latexmk',
          '.fls',
          '.lof',
          '.log',
          '.lot',
          '.nav',
          '.out',
          '.pdfsync',
          '.run.xml',
          '.snm',
          '.synctex.gz',
          '.toc',
          '.vrb',
          '.xdv',
          '.synctex',
          '.thm',
        }

        -- Safety check: make sure we're in a LaTeX project directory
        if vim.fn.filereadable(tex_dir .. '/' .. vim.fn.expand '%:t:r' .. '.tex') == 0 then
          vim.notify('Not in a LaTeX project directory or no .tex file found', vim.log.levels.WARN)
          return
        end

        local cleaned_files = 0
        for _, ext in ipairs(extensions) do
          local files = vim.fn.glob(tex_dir .. '/*' .. ext, false, true)
          for _, file in ipairs(files) do
            if vim.fn.filereadable(file) == 1 then
              vim.fn.delete(file)
              cleaned_files = cleaned_files + 1
            end
          end
        end

        vim.notify('Cleaned ' .. cleaned_files .. ' LaTeX auxiliary files', vim.log.levels.INFO)
      end, { desc = 'Clean LaTeX auxiliary files' })

      -- Auto cleanup events
      local latex_group = vim.api.nvim_create_augroup('vimtex_config', { clear = true })
      vim.api.nvim_create_autocmd('BufWinLeave', {
        pattern = '*.tex',
        group = latex_group,
        callback = function()
          -- Only clean if the file exists on disk (not a new unsaved file)
          if vim.fn.filereadable(vim.fn.expand '%') == 1 then
            vim.cmd 'LatexClean'
          end
        end,
      })
      vim.api.nvim_create_autocmd('VimLeave', {
        group = latex_group,
        callback = function()
          -- Only clean if in a tex file
          if vim.bo.filetype == 'tex' then
            vim.cmd 'LatexClean'
          end
        end,
      })

      -- Additional mappings for LaTeX documents
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        group = latex_group,
        callback = function()
          -- Set up local mappings for LaTeX files
          --          vim.keymap.set("n", "<leader>lc", "<cmd>LatexClean<CR>", { buffer = true, desc = "Clean auxiliary files" })
          --          vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", { buffer = true, desc = "Toggle TOC" })
          --          vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { buffer = true, desc = "View PDF" })
          --          vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { buffer = true, desc = "Compile document" })
          --          vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStop<CR>", { buffer = true, desc = "Stop compilation" })
          --          vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>", { buffer = true, desc = "Show errors" })

          -- Make sure spell checking is enabled for LaTeX files
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'en_us'
        end,
      })
    end,
  },
}
