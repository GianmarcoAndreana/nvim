-- plugins/lsp.lua
return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    opts = {
      ui = { border = 'rounded' },
      ensure_installed = { 'lua_ls', 'pyright', 'html', 'ruff', 'tinymist' },
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'williamboman/mason.nvim',
    opts = { automatic_installation = true },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp', -- ensure blink is available for capabilities
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
    end,
  },
}
