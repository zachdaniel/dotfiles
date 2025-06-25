return {
  -- {
  --   "ficcdaf/ashen.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("ashen").setup({
  --       style_presets = {
  --         bold_functions = true,
  --         italic_comments = false,
  --       },
  --       terminal = {
  --         colors = {
  --           [0] = "#121212",
  --           [1] = "#B14242",
  --           [2] = "#1E6F54",
  --           [3] = "#E49A44",
  --           [4] = "#949494",
  --           [5] = "#949494",
  --           [6] = "#a7a7a7",
  --           [7] = "#b4b4b4",
  --           [8] = "#d5d5d5",
  --           [9] = "#B14242",
  --           [10] = "#D87C4A",
  --           [11] = "#B14242",
  --           [12] = "#949494",
  --           [13] = "#a7a7a7",
  --           [14] = "#b4b4b4",
  --           [15] = "#d5d5d5"
  --         },
  --       }
  --     })
  --
  --     vim.cmd("colorscheme ashen")
  --   end
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
