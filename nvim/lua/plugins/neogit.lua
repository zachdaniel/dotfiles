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
    neogit.setup()
    dofile(vim.g.base46_cache .. "git")
    dofile(vim.g.base46_cache .. "neogit")
    vim.keymap.set("n", "<leader>gg", function()
      if vim.g.nvdash_displayed then
        require("nvchad.tabufline").close_buffer()
      end
      neogit.open()
    end, { desc = "Open Neogit" })
  end
}
