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
      { "<leader>b", group = "buffer" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "debug" }
    })

    -- Quickfix
    vim.keymap.set("n", "<leader>xx", function()
      require("quicker").toggle()
    end, { desc = "Toggle Quickfix" })

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

    -- Buffers
    vim.keymap.set("n", "<leader>bb", function()
      vim.cmd("bprev")
    end, { desc = "Previous buffer" })

    vim.keymap.set("n", "<leader>bn", function()
      vim.cmd("bnext")
    end, { desc = "Next buffer" })

    vim.keymap.set("n", "<leader>bc", function()
      vim.cmd("bd")
    end, { desc = "Close buffer" })

    vim.keymap.set("n", "<leader>bf", function()
      vim.cmd("Telescope buffers")
    end, { desc = "Find buffers" })

    -- Quit

    vim.keymap.set("n", "<leader>qq", function()
      vim.cmd("confirm quitall")
    end, { desc = "Quit neovim" })

    -- Thanks to BoostCoder
    -- In visual mode, shift J and K moves lines up and down
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

    -- stay in visual mode as indenting/outdenting
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
