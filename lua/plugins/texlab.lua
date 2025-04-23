return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  opts = {
    servers = {
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'latexmk',
              args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
              onSave = true,
            },
            forwardSearch = {
              executable = 'sumatra', -- change if needed: "okular", "sioyek", etc.
              args = { '--synctex-forward', '%l:1:%f', '%p' },
            },
            latexFormatter = 'latexindent',
            latexindent = {
              modifyLineBreaks = true,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    -- Load the LSP config with our options
    require('lspconfig').texlab.setup(opts.servers.texlab)

    -- Autoformat .tex files before saving
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.tex',
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}
