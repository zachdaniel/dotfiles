return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    terminal = {
      win = {
        wo = {
          winbar = ''
        }
      }
    },
    picker = {
      -- your picker configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    scratch = {
      root = "~/Documents/scratch/"
    },
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys",  gap = 1, padding = 1 },
        {
          pane = 1,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
      preset = {
        header = [[
╔═════════════════════════════════════════════════════╗
║                                                     ║
║                          ░                          ║
║                         ░░░                         ║
║                        ░▒▓▒░                        ║
║                       ░▒▓▓▓▒░                       ║
║                      ▒▒▓▓▓▓▓▒░                      ║
║                    ▒▒▓▓▓▓▓▓▓▓▒░                     ║
║                   ░▒▓▓▓▓▓▓▓▓▓▓▓▒                    ║
║                   ▒██▓▓▓▓▓▓▓▓▓▓▓▒░                  ║
║                 ░▒▒▒▓██▓▓▓▓▓▓▓▓▓▓▒░                 ║
║                ░░█▓▓▓▒███▓▓▓▓▓▓▓▓▓▒░                ║
║               ░░█▓▓▓▓▓▒▒███▓▓▓▓▓▓▓▓▒░               ║
║              ░▒█▓▓▓▓▓▓▓▓▒▒███▓▓▓▓▓▓▓▒░              ║
║            ░░▓▒█▓▓▓▓▓▓▓▓▓▓▓▒███▓▓▓▓▓▓▒░             ║
║           ░▒▓▒█▓▓▓▓▓▓▓▓▓▓▓█▓▒████▓▓▓▓▓▓▒            ║
║          ░▒▓▓▒█▓▓▓▓▓▓▓▓▓██▒▒▒▒▓▒███▓▓▓▓▓▒░          ║
║         ░▒▓▓▒█▓▓▓▓▓▓▓▓▓█▓▒▓▓▓▓▒█▓▒███▓▓▓▓▒░         ║
║        ░▒▓▓▒▓█▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▒█▓▒▒███▓▓▓▒░        ║
║       ░▒▓▓▓▒█▓▓▓▓▓▓▓█▒███▒▒▒▓▓▓▓▒█▓▓▒▒███▓▓▒░       ║
║     ░▒▓▓▓▓▒█▓▓▓▓▓▓██▒▒█████▒▒▒▒▓▓▒▓█▓▓▒▒███▓▒░      ║
║    ░▒▓▓▓▓▓▒█▓▓▓▓▓█▒▒▓▒█▓▓▓████▒▒▒▒▒▓█▓▓▓▒▒███▓░     ║
║   ░▒▓▓▓▓▓▒█▓▓▓▓██▒▓▓▓▒█▓▓▓▓▓████▒▒▒▒▓█▓▓▓▓▒▒██▓▒░   ║
║  ░▒▓▓▓▓▓▓▒█▓▓██▒▒▓▓▓▓▒█▓▓▓▓▓▓▓▓████▒▒▒▓▓▓▓▓▓▒▒██▓░  ║
║                                                     ║
║                                                     ║
║               █████╗ ███████╗██╗  ██╗               ║
║              ██╔══██╗██╔════╝██║  ██║               ║
║              ███████║███████╗███████║               ║
║              ██╔══██║╚════██║██╔══██║               ║
║              ██║  ██║███████║██║  ██║               ║
║              ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝               ║
╚═════════════════════════════════════════════════════╝
        ]]
      }
    }
  },
  keys = {
    -- { "<leader>.",  function() Snacks.scratch() end,        desc = "Toggle Scratch Buffer" },
    -- { "<leader>fs", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- {
    --   "<leader>fS",
    --   function()
    --     vim.ui.input({ prompt = 'Enter name: ' }, function(input)
    --       local name = input
    --       if not name:match("%.md$") then
    --         name = name .. ".md"
    --       end
    --       Snacks.scratch({ name = name })
    --     end)
    --   end,
    --   desc = "Create scratch buffer"
    -- },
    --
    -- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    -- vim.keymap.set("n", "<leader>ss", builtin.live_grep, { desc = "Telescope project search" })
    {"<leader>ff", function() 
      Snacks.picker.files({hidden = true})
    end},
    {"<leader>ss", function()
      Snacks.picker.grep({hidden = true})
    end},
    {
      "<D-`>",
      function()
        local in_terminal = vim.bo.buftype == "terminal"
        if in_terminal then
          vim.cmd("hide")
        else
          Snacks.terminal.toggle()
        end
      end,
      desc = "Toggle Terminal",
      mode = { "n", "v", "t", "i" }
    },
    {
      "<leader>tt",
      function()
        local in_terminal = vim.bo.buftype == "terminal"
        if in_terminal then
          vim.cmd("hide")
        else
          Snacks.terminal.toggle()
        end
      end,
      desc = "Toggle Terminal",
      mode = { "n", "v" }
    }
  }
}
