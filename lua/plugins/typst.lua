-- init.lua or plugins/typst.lua
return {
  -- Typst preview plugin
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    build = function()
      require('typst-preview').update() -- download/update preview binary :contentReference[oaicite:0]{index=0}
    end,
    config = function()
      require('typst-preview').setup { -- default settings
        debug = false,
        invert_colors = 'auto',
        follow_cursor = true,
      }

      -- Keymaps: bind <leader>tp to toggle the preview buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'typst',
        callback = function()
          -- Toggle preview window
          vim.keymap.set('n', '<leader>tp', ':TypstPreviewToggle<CR>', { buffer = true })
          -- Force-sync cursor position to preview
          vim.keymap.set('n', '<leader>ts', ':TypstPreviewSyncCursor<CR>', { buffer = true })
          -- Stop preview
          vim.keymap.set('n', '<leader>tS', ':TypstPreviewStop<CR>', { buffer = true })
        end,
      }) -- Ngrok-style autocmd+keymap :contentReference[oaicite:1]{index=1}
    end,
  },

  -- LSP configuration for tinymist
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tinymist = {
          single_file_support = true,
          settings = {
            exportPdf = 'onType', -- live PDF export as you type :contentReference[oaicite:2]{index=2}
            outputPath = '$root/$dir/$name', -- see explanation below :contentReference[oaicite:3]{index=3}
            preview = {
              background = {
                enabled = true,
                args = { '--invert-colors=auto' },
              },
            },
          },
        },
      },
    },
  },
}
