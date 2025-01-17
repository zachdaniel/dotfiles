return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      -- Change the default chat adapter
      chat = {
        adapter = "openai"
      },
      inline = {
        adapter = "openai",
      },
    },
    opts = {
      -- Set debug logging
      log_level = "DEBUG",
    },
    display = {
      action_palette = {
        provider = 'telescope'
      }
    }
  },
  keys = {
    {
      "<leader>aa",
      function()
        vim.cmd("CodeCompanionActions")
      end,
      desc = "AI Actions"
    },
    {
      "<leader>at",
      function()
        vim.cmd("CodeCompanionChat Toggle")
      end,
      desc = "Toggle AI Chat"
    },
    {
      "<leader>ar",
      function()
        vim.cmd("CodeCompanion")
      end,
      desc = "Prompt AI for Replacement",
      mode = {"v"}
    }
  }
}
