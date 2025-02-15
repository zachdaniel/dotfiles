return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      background_colour = "#121212"
    })

    vim.notify = require("notify")
  end
}
