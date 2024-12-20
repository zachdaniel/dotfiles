return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  opts = {
    keymap = { preset = 'super-tab' },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion' },
    },
    ghost_text = {
      enabled = true,
    },
    menu = {
      winblend = 0
    },
    providers = {
      codecomponion = {
        name = "CodeCompanion",
        module = "codecompanion.providers.completion.blink",
        enabled = true
      }
    },

    -- experimental signature help support
    signature = { enabled = true }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" }
}
