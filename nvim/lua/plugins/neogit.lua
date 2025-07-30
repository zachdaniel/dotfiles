return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua",              -- optional
    -- "echasnovski/mini.pick",         -- optional
  },
  config = function()
    local neogit = require("neogit")
    neogit.setup({})
    vim.keymap.set("n", "<leader>gg", function()
      neogit.open()
    end, { desc = "Open Neogit" })

    vim.keymap.set("n", "<leader>gv", function()
      neogit.open({ kind = "split" })
    end, { desc = "Open Neogit" })

    vim.keymap.set("n", "<leader>gv", function()
      neogit.open({ kind = "vsplit" })
    end, { desc = "Open Neogit" })
  end
}
