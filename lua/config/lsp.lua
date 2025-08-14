-- lua/config/lsp.lua

-- Safety: make sure these plugins are present
local ok_mason, mason = pcall(require, 'mason')
local ok_mlsp, mason_lspconfig = pcall(require, 'mason-lspconfig')
local ok_lsp, lspconfig = pcall(require, 'lspconfig')
if not (ok_mason and ok_mlsp and ok_lsp) then
  vim.notify('LSP: missing mason/mason-lspconfig/nvim-lspconfig', vim.log.levels.WARN)
  return
end

-- Mason setup
mason.setup { ui = { border = 'rounded' } }
mason_lspconfig.setup {
  automatic_installation = true, -- auto-install servers you set up below
}

-- LSP capabilities via blink.cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, 'blink.cmp')
if ok_blink and blink.get_lsp_capabilities then
  capabilities = blink.get_lsp_capabilities(capabilities)
else
  capabilities.textDocument.completion.completionItem.snippetSupport = true
end

-- Diagnostics UI
local sev = vim.diagnostic.severity
vim.diagnostic.config {
  signs = {
    text = {
      [sev.ERROR] = '󰅚 ',
      [sev.WARN] = '󰀪 ',
      [sev.HINT] = '󰋽 ',
      [sev.INFO] = '󰌶 ',
    },
    -- Optional: highlight the number column per severity (uncomment if you want it)
    -- numhl = {
    --   [sev.ERROR] = "DiagnosticSignError",
    --   [sev.WARN]  = "DiagnosticSignWarn",
    --   [sev.HINT]  = "DiagnosticSignHint",
    --   [sev.INFO]  = "DiagnosticSignInfo",
    -- },
  },
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, prefix = '●' },
  severity_sort = true,
  float = { border = 'rounded' },
}

-- Safe global border patch for LSP floating windows
if not vim.g.__lsp_floating_border_patched then
  local util = vim.lsp.util
  local orig = util.open_floating_preview

  ---@diagnostic disable-next-line: duplicate-set-field
  function util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig(contents, syntax, opts, ...)
  end

  vim.g.__lsp_floating_border_patched = true
end

-- Keymaps on attach (global via autocmd)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspAttachKeymaps', { clear = true }),
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'Goto Implementation')
    map('n', 'gr', vim.lsp.buf.references, 'References')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('n', 'gl', vim.diagnostic.open_float, 'Line Diagnostics')
    map('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
    map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
    map('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, 'Format Buffer')
  end,
})

-- TS server name compatibility across lspconfig versions
local ts_name = lspconfig.ts_ls and 'ts_ls' or 'tsserver'

-- Per-server settings
local servers = {
  [ts_name] = {
    -- Example: disable tsserver formatting if you use prettier elsewhere
    -- on_attach = function(client) client.server_capabilities.documentFormattingProvider = false end,
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'basic', -- "off" | "basic" | "strict"
          autoImportCompletions = true,
        },
      },
    },
  },
  bashls = {},
  jsonls = {},
  yamlls = { settings = { yaml = { keyOrdering = false } } },
  html = {},
  cssls = {},
  dockerls = {},
  marksman = {}, -- Markdown
  gopls = {},
  rust_analyzer = {},
  clangd = {},
}

-- Setup each server with shared capabilities
for name, opts in pairs(servers) do
  local cfg = vim.tbl_deep_extend('force', {
    capabilities = vim.deepcopy(capabilities),
  }, opts or {})
  if lspconfig[name] then
    lspconfig[name].setup(cfg)
  else
    vim.notify(("LSP: unknown server '%s'"):format(name), vim.log.levels.WARN)
  end
end
