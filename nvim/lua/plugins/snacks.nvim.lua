return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    terminal = {
      -- your terminal configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  keys = {
    {
      "<D-`>",
      function()
        local in_terminal = vim.bo.buftype == "terminal"
        if in_terminal then
          vim.cmd("hide")
        else
          Snacks.terminal.toggle()
        end
      end,
      desc = "Toggle Terminal",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<leader>tt",
      function()
        local in_terminal = vim.bo.buftype == "terminal"
        if in_terminal then
          vim.cmd("hide")
        else
          Snacks.terminal.toggle()
        end
      end,
      desc = "Toggle Terminal",
      mode = { "n", "v" }
    }
    -- { "<leader>tt", toggle_term, desc = "Toggle Terminal" },
  }
}
