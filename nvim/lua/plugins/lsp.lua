return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "synic/refactorex.nvim",
    ft = "elixir",
    ---@module "refactorex.nvim"
    ---@type refactorex.Config
    opts = {
      auto_update = true,
      pin_version = nil,
    }
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      }
    },
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig", "folke/snacks.nvim" },
    ensure_installed = {
      { "elixir-ls", auto_update = true },
      { "lua_ls",    auto_update = true },
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()
      original_handler = vim.lsp.handlers['window/showMessage']
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }

        local function buf_set_keymap(...)
          vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("v", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("n", "<leader>cr", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
        if (client.name == "elixirls") then
          vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
            local lvl = ({
              'ERROR',
              'WARN',
              'INFO',
              'DEBUG',
            })[result.type]

            local vim_lvl = ({
              ['ERROR'] = vim.log.levels.ERROR,
              ['WARN'] = vim.log.levels.WARN,
              ['INFO'] = vim.log.levels.INFO,
              ['DEBUG'] = vim.log.levels.DEBUG,
            })[lvl]

            vim.notify(
              result.message,
              vim_lvl,
              {
                title = 'LSP | ' .. client.name,
              }
            )
          end
        end
      end
      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach })
        end,
        elixirls = function()
          require("lspconfig").elixirls.setup({
            on_attach = on_attach
          })
        end,
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              })
            end,
            settings = {
              Lua = {}
            }
          })
        end
      })
    end
  },
  {
    "neovim/nvim-lspconfig"
  },
}
