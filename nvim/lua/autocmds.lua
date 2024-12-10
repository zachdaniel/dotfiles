vim.api.nvim_create_augroup("fileopen", {})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
  group = "fileopen",
  callback = function()
    if vim.bo.filetype ~= "" then
      return
    end

    if vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "" then
      require("telescope.builtin").find_files()
    end
  end
})
