return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    indent = {},
    terminal = {
      win = {
        wo = {
          winbar = ''
        }
      }
    },
    picker = {
      matcher = {
        frecency = true
      }
    },
    notifier = { enabled = false },
    image = {},
    scratch = {
      root = ".cratch/"
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

    { "<leader>.", function() Snacks.scratch() end, desc = "Open persistent scratch" },
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
    {
      "<leader>ss",
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = "Search all files"
    },
    {
      "<D-`>",
      function()
        local in_terminal = vim.bo.buftype == "terminal"
        if in_terminal then
          -- Check if this is a Claude Code buffer
          local buf_name = vim.api.nvim_buf_get_name(0)
          local is_claude = buf_name:lower():match("claude") ~= nil

          if is_claude then
            -- If we're in Claude Code, open terminal
            Snacks.terminal.toggle()
          else
            -- For other terminals, hide as before
            vim.cmd("hide")
          end
        else
          Snacks.terminal.toggle()
        end
      end,
      desc = "Toggle Terminal",
      mode = { "n", "v", "t", "i" }
    },
    -- Terminal tab keybindings (CMD+1 through CMD+9)
    {
      "<D-1>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "1" } })
      end,
      desc = "Terminal 1",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-2>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "2" } })
      end,
      desc = "Terminal 2",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-3>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "3" } })
      end,
      desc = "Terminal 3",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-4>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "4" } })
      end,
      desc = "Terminal 4",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-5>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "5" } })
      end,
      desc = "Terminal 5",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-6>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "6" } })
      end,
      desc = "Terminal 6",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-7>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "7" } })
      end,
      desc = "Terminal 7",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-8>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "8" } })
      end,
      desc = "Terminal 8",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<D-9>",
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERMINAL_ID = "9" } })
      end,
      desc = "Terminal 9",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<leader>tl",
      function()
        local terminals = Snacks.terminal.list()
        if #terminals == 0 then
          vim.notify("No active terminals", vim.log.levels.INFO)
        else
          local items = {}
          for _, term in ipairs(terminals) do
            table.insert(items, {
              text = string.format("Terminal %s", term.id or "default"),
              action = function()
                term:show()
              end
            })
          end
          Snacks.picker.select(items, { prompt = "Select Terminal" })
        end
      end,
      desc = "List terminals"
    }
  }
}
