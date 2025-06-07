return {
  "olimorris/codecompanion.nvim",
  opts = {
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
          auto_approve = true
        }
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim"
  },
}
-- return {
-- "olimorris/codecompanion.nvim",
-- dependencies = {
--   "nvim-lua/plenary.nvim",
--   "nvim-treesitter/nvim-treesitter",
-- },
-- opts = {
--   strategies = {
--     -- Change the default chat adapter
--     chat = {
--       adapter = "openai"
--     },
--     inline = {
--       adapter = "openai",
--     },
--   },
--   opts = {
--     -- Set debug logging
--     log_level = "DEBUG",
--   },
--   display = {
--     action_palette = {
--       provider = 'telescope'
--     }
--   }
-- },
-- keys = {
--   {
--     "<leader>aa",
--     function()
--       vim.cmd("CodeCompanionActions")
--     end,
--     desc = "AI Actions"
--   },
--   {
--     "<leader>at",
--     function()
--       vim.cmd("CodeCompanionChat Toggle")
--     end,
--     desc = "Toggle AI Chat"
--   },
--   {
--     "<leader>ar",
--     function()
--       vim.cmd("CodeCompanion")
--     end,
--     desc = "Prompt AI for Replacement",
--     mode = {"v"}
--   }
-- }
-- }
