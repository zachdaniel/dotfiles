return {
  "mbbill/undotree",
  keys = {
    {
      "<leader>ou",
      function()
        vim.cmd("UndotreeToggle")
      end,
      desc = "Open Undotree"
    },
  },
}
