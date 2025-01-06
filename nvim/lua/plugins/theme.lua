return {
  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    install = function()
      require("ashen").setup({
        hl = {
          merge_override = {
            NotifyBackground = "#121212"
          }
        }
      })

      vim.cmd("colorscheme ashen")
    end
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   lazy = false,
  --   setup = function()
  --     vim.cmd("colorscheme catppuccin")
  --     require("catppuccin").setup({
  --       transparent_background = true,
  --       flavor = "mocha"
  --     })
  --   end
  -- },
}
