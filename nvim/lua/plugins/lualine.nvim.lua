return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons',

    "ficcdaf/ashen.nvim",
  },
  config = function()
    local ashen = require("ashen.plugins.lualine").lualine_opts
    ashen.extensions = { "lazy", "fzf" }
    -- ashen.sections = {
    --   lualine_x = {
    --     {
    --       require("noice").api.status.message.get_hl,
    --       cond = require("noice").api.status.message.has,
    --     },
    --     {
    --       require("noice").api.status.command.get,
    --       cond = require("noice").api.status.command.has,
    --       color = { fg = "#ff9e64" },
    --     },
    --     {
    --       require("noice").api.status.mode.get,
    --       cond = require("noice").api.status.mode.has,
    --       color = { fg = "#ff9e64" },
    --     },
    --     {
    --       require("noice").api.status.search.get,
    --       cond = require("noice").api.status.search.has,
    --       color = { fg = "#ff9e64" },
    --     },
    --   },
    -- }
    --
    require("lualine").setup(ashen)
  end
}
