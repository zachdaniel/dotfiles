return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>f", group = "file" },
      { "<leader>t", group = "term" }
    })
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
