return { 'echasnovski/mini.nvim', version = '*',
  config = function()
    local minifiles = require("mini.files")
    minifiles.setup({})

    vim.keymap.set("n", "<leader>ft", function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      minifiles.open(path)
      minifiles.reveal_cwd()
    end, { desc = "Open Mini Files" })
  end
}
