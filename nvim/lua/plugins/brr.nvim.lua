return {
  "leobeosab/brr.nvim",
  opts = {
    root = "~/Documents/scratch", -- Root where all scratch files are stored, I throw mine in an Obsidian vault
    style = {
      width = 0.8,                -- 0-1, 1 being full width, 0 being, well, 0
      height = 0.8,               -- 0-1
      title_padding = 2           -- number of spaces as padding in the top border title
    }
  },
  keys = { -- You'll probably want to change my weird keybinds, these are just examples
    { "<leader>.",  "<cmd>Scratch scratch.md<cr>", desc = "Open persistent scratch" },
    {
      "<leader>fS",
      function()
        vim.ui.input({ prompt = 'Enter scratch file name: ' }, function(input)
          if input then
            if not input:match("%.md$") then
              input = input .. ".md"
            end
            vim.cmd("Scratch " .. input)
          end
        end)
      end,
      desc = "Open new scratch file"
    },
    { "<leader>fs", "<cmd>ScratchList<cr>",        desc = "Find scratch" }
  }
}
