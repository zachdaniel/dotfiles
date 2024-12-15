vim.keymap.set("n", "<leader>wv", function()
vim.cmd("vsplit")
end, { desc = "Vertical split"})

vim.keymap.set("n", "<leader>wh", function()
  vim.cmd("split")
end, { desc = "Horizontal split"})

vim.keymap.set("n", "<leader>ww", function()
  vim.cmd("wincmd w")
end, { desc = "Next window"})

-- vim.keymap.set("n", "<leader>tt", function()
--   vim.cmd("terminal")
-- end, { desc = "Toggle Terminal"})
