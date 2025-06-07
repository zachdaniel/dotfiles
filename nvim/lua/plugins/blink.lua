-- return {
--   {
--     'saghen/blink.compat',
--     -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
--     version = '*',
--     -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
--     lazy = true,
--     -- make sure to set opts so that lazy.nvim calls blink.compat's setup
--     opts = {},
--   },
--   {
--     'saghen/blink.cmp',
--     -- optional: provides snippets for the snippet source
--     -- dependencies = 'rafamadriz/friendly-snippets',
--
--     -- use a release tag to download pre-built binaries
--     -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
--     -- build = 'cargo build --release',
--     -- If you use nix, you can build from source using latest nightly rust with:
--     -- build = 'nix run .#build-plugin',
--     opts = {
--       -- 'default' for mappings similar to built-in completion
--       -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
--       -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
--       -- See the full "keymap" documentation for information on defining your own keymap.
--       keymap = { preset = 'super-tab' },
--
--       appearance = {
--         -- Sets the fallback highlight groups to nvim-cmp's highlight groups
--         -- Useful for when your theme doesn't support blink.cmp
--         -- Will be removed in a future release
--         use_nvim_cmp_as_default = true,
--         -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--         -- Adjusts spacing to ensure icons are aligned
--         nerd_font_variant = 'mono'
--       },
--       -- Default list of enabled providers defined so that you can extend it
--       -- elsewhere in your config, without redefining it, due to `opts_extend`
--       sources = {
--         default = { 'lsp', 'path', 'snippets', 'buffer' },
--         providers = {
--         },
--       },
--     },
--     opts_extend = { "sources.default" }
--   }
-- }
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
