return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons',

    "ficcdaf/ashen.nvim",
  },
  config = function()
    local ashen = require("ashen.plugins.lualine").lualine_opts
    ashen.extensions = { "lazy", "fzf" }
    require("lualine").setup(ashen)
  end
}
