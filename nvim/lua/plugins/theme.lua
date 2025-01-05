return {
  {
    "ficcdaf/ashen.nvim",
    install = function()
      require("ashen").setup({
        force_hi_clear = true,
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
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       transparent = true,
  --       borderless_telescoep = true,
  --       terminal_colors = true
  --     })
  --
  --     vim.cmd("colorscheme catppuccin")
  --   end
  -- }
}
