return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local codecompanion = require("codecompanion")
    codecompanion.setup({
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "OPEN_AI_API_KEY"
            },
          })
        end,
      },
      opts = {
        strategies = {
          --NOTE: Change the adapter as required
          chat = { adapter = "copilot" },
          inline = { adapter = "copilot" },
        }
      }
    })

    vim.keymap.set("n", "<leader>aa", function()
      vim.cmd("CodeCompanionActions")
    end, { desc = "AI Actions" })

    vim.keymap.set("n", "<leader>at", function()
      vim.cmd("CodeCompanionChat Toggle")
    end, { desc = "Toggle AI Chat" })

    vim.keymap.set("n", "<leader>ar", function()
      vim.cmd("CodeCompanion")
    end, { desc = "Prompt AI for Replacement" })
  end
}
