return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
    -- Allows extra capabilities provided by blink-cmp
    { 'saghen/blink.cmp' },
  },
  config = function()
    -- Brief aside: **What is LSP?**
    -- (keep your existing commentary here)

    -- This function runs when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- Document highlight
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(ev)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = ev.buf }
            end,
          })
        end

        -- Inlay hints
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Format vs indent on save
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_formatting, buf) then
          if client.name == 'texlab' then
            -- For TeX, only auto-indent without moving cursor or echoing messages
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('kickstart-tex-indent', { clear = false }),
              buffer = buf,
              callback = function()
                local win = vim.api.nvim_get_current_win()
                local cur = vim.api.nvim_win_get_cursor(win)
                -- silent undojoin and indent entire buffer in one command
                vim.cmd 'silent! undojoin | normal! gg=G'
                vim.api.nvim_win_set_cursor(win, cur)
              end,
            })
          else
            -- For other filetypes, full LSP format on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-format', { clear = true }),
              buffer = buf,
              callback = function()
                vim.lsp.buf.format {
                  async = false,
                  bufnr = buf,
                  timeout_ms = 5000,
                  filter = function(c)
                    return c.id == client.id
                  end,
                }
              end,
            })
          end
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          return d.message
        end,
      },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))
    capabilities = vim.tbl_deep_extend('force', capabilities, {
      textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
    })

    -- Enable language servers
    local servers = {
      lua_ls = {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      },
      texlab = {
        settings = {
          texlab = {
            build = {
              executable = 'latexmk',
              args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
              onSave = false, -- disable build on save
            },
            forwardSearch = {
              executable = 'sumatra',
              args = { '--synctex-forward', '%l:1:%f', '%p' },
            },
            chktex = { onEdit = true, onOpenAndSave = true },
            latexFormatter = 'latexindent',
            latexindent = { modifyLineBreaks = true },
          },
        },
      },
    }

    -- Ensure servers and tools are installed
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua', 'ruff', 'pyright' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local opts = vim.tbl_deep_extend('force', {}, capabilities, servers[server_name] or {})
          require('lspconfig')[server_name].setup(opts)
        end,
      },
    }
  end,
}
