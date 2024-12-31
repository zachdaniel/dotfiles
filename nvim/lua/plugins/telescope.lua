return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          }
        }
      },
      pickers = {
        find_files = {
          hidden = true
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end
        }
      }
    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>ss", builtin.live_grep, { desc = "Telescope project search" })
    -- vim.keymap.set("n", "C-q", "
    -- TODO: figure out how to send results to quickfix list by default
    -- i.e having two separate keybinds, like `<leader>ss` which searches to jump and
    -- <leader>sf which searches to save and fix
  end
}
