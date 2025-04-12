return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    local minifiles = require("mini.files")
    local minimove = require("mini.move")
    -- local minivisits = require("mini.visits")
    -- local minipairs = require("mini.pairs")
    -- minipairs.setup({})
    minifiles.setup({})
    -- minivisits.setup({})
    minimove.setup({
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',
      }
    })

    vim.keymap.set("n", "<leader>ft", function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      minifiles.open(path)
      minifiles.reveal_cwd()
    end, { desc = "Open Mini Files" })
  end
}
