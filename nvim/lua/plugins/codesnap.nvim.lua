return {
  "mistricky/codesnap.nvim",
  build = "make",
  config = function()
    local codesnap = require("codesnap")

    codesnap.setup({
      save_path = "~/Desktop",
      watermark = "",
      code_font_family = "JetBrains Mono",
      has_breadcrumbs = false,
      has_line_number = false,
      -- mac_window_bar = false
    })


    vim.keymap.set("v", "<Leader>hl", function()

      local codesnap2 = require("codesnap")
      codesnap2.setup({
        save_path = "~/Desktop",
        watermark = "",
        code_font_family = "JetBrains Mono",
        has_breadcrumbs = true,
        has_line_number = true
      })

      local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'x', false)
      vim.cmd("CodeSnapSave")
    end, { desc = "Save screenshot with location info"})

    vim.keymap.set("v", "<Leader>hh", function()
      local codesnap2 = require("codesnap")
      codesnap2.setup({
        save_path = "~/Desktop",
        watermark = "",
        code_font_family = "JetBrains Mono",
        has_breadcrumbs = false,
        has_line_number = false
      })

      local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'x', false)

      vim.cmd("<Esc>CodeSnapSave")
    end, { desc = "Save screenshot"})
  end
}
