return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      display = {
        action_palettte = {
          provider = "telescope"
        }
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "OPEN_AI_API_KEY"
            },
          })
        end,
      },
    })
  end
}
