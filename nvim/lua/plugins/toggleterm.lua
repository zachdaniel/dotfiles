 return {
   'akinsho/toggleterm.nvim', 
   version = "*",
   config = function()
    local terminal = require("toggleterm");
    vim.keymap.set({"n", "t"}, "<c-t>", terminal.toggle, { desc = "Telescope find files"})
   end
 }
