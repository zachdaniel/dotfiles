return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("telescope").setup({
      pickers = {
        find_files = {
          hidden = true
        }
      }
    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files"})
    vim.keymap.set("n", "<leader>ss", builtin.live_grep, { desc = "Telescope project search"})
    -- TODO: figure out how to send results to quickfix list by default
    -- i.e having two separate keybinds, like `<leader>ss` which searches to jump and
    -- <leader>sf which searches to save and fix
  end
}
