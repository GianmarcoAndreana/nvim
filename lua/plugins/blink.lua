-- lua/plugins/blink.lua
return {
  'saghen/blink.cmp',
  main = 'blink.cmp', -- makes lazy call require("blink.cmp").setup(opts)
  -- no version pin => follow latest commit; remove this if you pin versions elsewhere
  dependencies = {
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    { 'rafamadriz/friendly-snippets' },
  },
  opts = {
    keymap = { preset = 'default' }, -- try "super-tab" if you prefer Tab to navigate
    sources = {
      default = { 'lsp', 'path', 'buffer', 'snippets' },
    },
    -- Note: omit `appearance.use_nvim_cmp_kinds` for compatibility
  },
}
