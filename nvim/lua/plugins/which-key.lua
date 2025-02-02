local function confirm_and_delete_buffer()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand "%")
    vim.api.nvim_buf_delete(0, { force = true })
  end
end

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
      { "<leader>o", group = "open",    icon = "|>" },
      { "<leader>t", group = "terminal" },
      { "<leader>b", group = "buffer" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "debug" }
    })

    -- Don't yank when pasting

    vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

    -- Quickfix
    vim.keymap.set("n", "<leader>xx", function()
      require("quicker").toggle()
    end, { desc = "Toggle Quickfix" })

    vim.keymap.set("n", "<leader>xc", function()
      require("quicker").close()
    end, { desc = "Close Quickfix" })

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
      vim.cmd("bnext")
    end, { desc = "Next buffer" })

    vim.keymap.set("n", "<leader>bp", function()
      vim.cmd("bprev")
    end, { desc = "Previous buffer" })

    -- Open

    vim.keymap.set("n", "<leader>od", function()
      require("snacks").dashboard()
    end, { desc = "Open Dashboard" })


    vim.keymap.set("n", "<leader>bc", function()
      vim.cmd("bd")
    end, { desc = "Close buffer" })

    vim.keymap.set("n", "<leader>bf", function()
      Snacks.picker.buffers()
    end, { desc = "Find buffers" })

    -- Quit

    vim.keymap.set("n", "<leader>qq", function()
      vim.cmd("confirm quitall")
    end, { desc = "Quit neovim" })

    vim.keymap.set("n", "<leader>qh", function()
      vim.cmd("noh")
    end, { desc = "Dismiss highlights" })

    -- vim.keymap.set("n", "<leader>qn", function()
    --   vim.cmd("NoiceDismiss")
    -- end, { desc = "Dismiss notifications" })

    -- Files
    vim.keymap.set('n', '<leader>fd', confirm_and_delete_buffer, { desc = "Delete current file" })

    -- Thanks to BoostCoder
    -- In visual mode, shift J and K moves lines up and down
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

    -- stay in visual mode as indenting/outdenting
    vim.keymap.set("v", ">", ">gv")
    vim.keymap.set("v", "<", "<gv")

    -- movement
    vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })

    -- swapping up/down
    vim.keymap.set('n', '<C-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true })
    vim.keymap.set('n', '<C-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true })
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
