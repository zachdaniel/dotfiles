return { 'echasnovski/mini.nvim', version = '*',
  config = function()
    local minifiles = require("mini.files")
    minifiles.setup({})

    vim.keymap.set("n", "<leader>ft", minifiles.open, { desc = "Open Minifiles" })
  end
}
