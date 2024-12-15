 return {
   'akinsho/toggleterm.nvim', 
   version = "2.12.0",
   config = function()
    local terminal = require("toggleterm");
    vim.keymap.set("n", "<Leader>tt", terminal.toggle, { desc = "Toggle Terminal"})
    vim.keymap.set({"n", "t"}, "<C-t>", terminal.toggle, { desc = "Toggle Terminal"})
   end
 }
