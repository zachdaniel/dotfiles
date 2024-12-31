return {
  'stevearc/quicker.nvim',
  event = "FileType qf",
  opts = {
    keys = { {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
        vim.api.nvim_win_set_height(0, math.min(25, vim.api.nvim_buf_line_count(0)))
      end,
      desc = "Expand quickfix context",
    },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      } },
  },
  keys = {
    -- {
    --   "<leader>xe",
    --   function()
    --     require("quicker").expand({
    --       add_to_existing = true,
    --     })
    --   end,
    --   desc = "Expand context",
    -- },
    -- {
    --   "n",
    --   "<leader>xx",
    --   function()
    --     require("quicker").toggle()
    --   end,
    --   desc = "Toggle quickfix"
    -- }
    -- {
    --   "<D-`>",
    --   function()
    --     local in_terminal = vim.bo.buftype == "terminal"
    --     if in_terminal then
    --       vim.cmd("hide")
    --     else
    --       Snacks.terminal.toggle()
    --     end
    --   end,
    --   desc = "Toggle Terminal",
    --   mode = { "n", "v", "t", "i" }
    -- },
    -- {
    --   "<leader>tt",
    --   function()
    --     local in_terminal = vim.bo.buftype == "terminal"
    --     if in_terminal then
    --       vim.cmd("hide")
    --     else
    --       Snacks.terminal.toggle()
    --     end
    --   end,
    --   desc = "Toggle Terminal",
    --   mode = { "n", "v" }
    -- }
    -- { "<leader>tt", toggle_term, desc = "Toggle Terminal" },
  }
}
