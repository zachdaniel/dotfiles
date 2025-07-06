return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    indent = {},
    picker = {
      matcher = {
        frecency = true
      }
    },
    notifier = { enabled = true },
    image = {},
    scratch = {
      root = "~/.scratch/"
    },
    dashboard = {
      sections = {
        { section = "header" },
        {
          footer = [[]],
          padding = 2,      -- Optional padding above/below the footer
          align = "center", -- Optional alignment (left, center, right)
          hl = "comment"
        },
        -- {
        --   pane = 2,
        --   section = "terminal",
        --   cmd = "cbonsai -l -i -L 30",
        --   height = 30,
        --   indent = 0,
        --   gap = 0,
        --   padding = 1
        -- },
        {
          pane = 3,
          section = "keys",
          gap = 1,
          indent = 5,
          padding = 0,
          align = "left"
        },
        {
          pane = 2,
          section = "startup"
        },
      },
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Git", action = ":Neogit" },
          {
            icon = " ",
            key = ".",
            desc = "Scratch",
            action = function()
              Snacks.scratch()
            end
          },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil }
        },
        header = [[]]
      }
    }
  },
  keys = {

    { "<leader>.",        function() Snacks.scratch() end,              desc = "Open persistent scratch" },
    {
      "<leader>fs",
      function()
        if vim.tbl_isempty(Snacks.scratch.list()) then
          Snacks.scratch()
        else
          Snacks.scratch.select()
        end
      end,
      desc = "Find scratch"
    },
    {
      "<leader>fn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Find notification"
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({ hidden = true })
      end,
      desc = "Find file"
    },
    { "<leader><leader>", function() Snacks.picker.commands() end,      desc = "Commands" },
    { "<leader>nn",       function() Snacks.picker.notifications() end, desc = "Notification History" },
    {
      "<leader>ss",
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = "Search all files"
    }
  }
}
