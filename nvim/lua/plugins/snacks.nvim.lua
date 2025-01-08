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
