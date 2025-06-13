vim.api.nvim_create_augroup("fileopen", {})

-- vim.api.nvim_create_autocmd({ "UIEnter" }, {
--   group = "fileopen",
--   callback = function()
--     if vim.bo.filetype ~= "" then
--       return
--     end
--
--     if vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "" then
--       require("telescope.builtin").find_files()
--     end
--   end
-- })

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(ev)
--     vim.schedule(function()
--       vim.api.nvim_buf_set_option(0, 'buftype', 'acwrite')
--       vim.api.nvim_buf_set_name(0, tostring(vim.api.nvim_get_current_win()))
--       vim.api.nvim_create_autocmd('BufWriteCmd', {
--         buffer = ev.data.buf_id,
--         callback = function()
--           require('mini.files').synchronize()
--         end,
--       })
--     end)
--   end,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("lsp", { clear = true }),
--   callback = function(args)
--     local file_ext = vim.fn.expand('%:e')
--     if file_ext ~= 'heex' then
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         buffer = args.buf,
--         callback = function()
--           vim.lsp.buf.format { async = false, id = args.data.client_id }
--         end,
--       })
--     end
--   end
-- })

vim.api.nvim_create_autocmd({ "RecordingEnter" }, {
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd({ "RecordingLeave" }, {
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

-- Autoread files when they change on the filesystem
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})
