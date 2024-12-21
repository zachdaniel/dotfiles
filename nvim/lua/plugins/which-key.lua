return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  config = function()
    local wk = require("which-key")

    wk.add({
      mode = { "n", "v" },
      { "<leader>f", group = "file" },
      { "<leader>t", group = "terminal" },
      { "<leader>g", group = "git" },
      { "<leader>w", group = "window" },
      { "<leader>s", group = "search" },
      { "<leader>q", group = "quit" },
      { "<leader>c", group = "quickfix" },
      { "<leader>h", group = "share" },
      { "<leader>a", group = "ai" }
    })

    -- Windows

    vim.keymap.set("n", "<leader>wv", function()
      vim.cmd("vsplit")
    end, { desc = "Vertical split"})

    vim.keymap.set("n", "<leader>wh", function()
      vim.cmd("split")
    end, { desc = "Horizontal split"})

    vim.keymap.set("n", "<leader>ww", function()
      vim.cmd("wincmd w")
    end, { desc = "Next window"})

    vim.keymap.set("n", "<leader>wc", function()
      vim.cmd("close")
    end, { desc = "Close window"})

    -- Quit

    vim.keymap.set("n", "<leader>qq", function()
      vim.cmd("confirm quit")
    end, { desc = "Quit neovim"})

    -- Quickfix
    -- Find a way to do this one with telescope?
    vim.keymap.set("n", "<leader>cs", function()
      local keys = vim.api.nvim_replace_termcodes(":grep  **<Left><Left><Left>", true, false, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end, { desc = "Search for quickfix" })

    vim.keymap.set("n", "<leader>cc", function()
      vim.cmd("cclose")
    end, { desc = "Close"})

    vim.keymap.set("n", "<leader>cn", function()
      vim.cmd("cnext")
    end, { desc = "Next item"})

    vim.keymap.set("n", "<leader>cp", function()
      vim.cmd("cprev")
    end, { desc = "Previous item"})

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
