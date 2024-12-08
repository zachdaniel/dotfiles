-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- {
    --   import = "plugins"
    -- },
    {
      "rebelot/kanagawa.nvim",
      config = function()
        vim.cmd([[colorscheme kanagawa-wave]])
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        lspconfig.clangd.setup({})
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function() 
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "erlang", "elixir", "rust", "javascript", "typescript" },

          auto_install = true,

          highlight = {
            enable = true,
          },

          incremental_selection = {
            enable = true,
            keymaps = {
              node_incremental = "v",
              node_decremental = "V",
            },
          },
          textobjects = {
            select = {
              enable = true,

              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,

              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "Select function"},
                ["if"] = { query = "@function.inner", desc = "Select function contents"},
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                -- You can also use captures from other query groups like `locals.scm`
                -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
              },
              -- You can choose the select mode (default is charwise 'v')
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * method: eg 'v' or 'o'
              -- and should return the mode ('v', 'V', or '<c-v>') or a table
              -- mapping query_strings to modes.
              selection_modes = {
                ['@function.outer'] = 'V', -- linewise
                ['@function.inner'] = 'v', -- linewise
              },
              -- If you set this to `true` (default is `false`) then any textobject is
              -- extended to include preceding or succeeding whitespace. Succeeding
              -- whitespace has priority in order to act similarly to eg the built-in
              -- `ap`.
              --
              -- Can also be a function which gets passed a table with the keys
              -- * query_string: eg '@function.inner'
              -- * selection_mode: eg 'v'
              -- and should return true or false
              include_surrounding_whitespace = true,
            },
          },
        }) end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects"
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = { 
    enabled = true,
    notify = false
  }
})

