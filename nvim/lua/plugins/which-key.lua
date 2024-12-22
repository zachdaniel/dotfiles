return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.icons"
  },
  opts = {
  },
  config = function()
    local wk = require("which-key")

    wk.add({
      mode = { "n", "v" },
      { "<leader>a", group = "ai" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "share" },
      { "<leader>q", group = "quit" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "terminal" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "debug" }
    })

    -- Windows

    vim.keymap.set("n", "<leader>wv", function()
      vim.cmd("vsplit")
    end, { desc = "Vertical split" })

    vim.keymap.set("n", "<leader>wh", function()
      vim.cmd("split")
    end, { desc = "Horizontal split" })

    vim.keymap.set("n", "<leader>ww", function()
      vim.cmd("wincmd w")
    end, { desc = "Next window" })

    vim.keymap.set("n", "<leader>wc", function()
      vim.cmd("close")
    end, { desc = "Close window" })

    -- Quit

    vim.keymap.set("n", "<leader>qq", function()
      vim.cmd("confirm quit")
    end, { desc = "Quit neovim" })

    -- Thanks to BoostCoder
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
    vim.keymap.set("v", ">", ">gv")
    vim.keymap.set("v", "<", "<gv")
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer local keymaps (which-key)"
    }
  }
}
