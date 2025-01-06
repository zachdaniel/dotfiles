return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    terminal = {
      -- your terminal configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys",  gap = 1, padding = 1 },
        {
          pane = 2,
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
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
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
    -- { "<leader>tt", toggle_term, desc = "Toggle Terminal" },
  }
}
