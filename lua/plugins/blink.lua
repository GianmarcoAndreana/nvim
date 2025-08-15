-- lua/plugins/blink.lua
return {
  'saghen/blink.cmp',
  version = '1.*', -- use a tagged release with prebuilts
  main = 'blink.cmp',
  dependencies = {
    { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
    { 'rafamadriz/friendly-snippets' },
  },
  opts = {
    keymap = { preset = 'default' },
    sources = { default = { 'lsp', 'path', 'buffer', 'snippets' } },
  },
}
