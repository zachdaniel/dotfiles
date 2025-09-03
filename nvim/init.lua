vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/mbbill/undotree",
  "https://github.com/aaronik/treewalker.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/catppuccin/nvim.git",
  "https://github.com/folke/flash.nvim",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/ray-x/lsp_signature.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/alexghergh/nvim-tmux-navigation",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  "https://github.com/Kaiser-Yang/blink-cmp-avante",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/yetone/avante.nvim",
})

-- Colorscheme
vim.cmd.colorscheme "catppuccin"

-- Basic Options
--- line numbers
vim.opt.number = true

--- preferred location for splits
vim.opt.splitbelow = true
vim.opt.splitright = true

--- don't do line wrapping
vim.opt.wrap = false

--- use spaces instead of tabs
local default_tab_size = 2

vim.opt.expandtab = true
vim.opt.tabstop = default_tab_size
vim.opt.shiftwidth = default_tab_size

--- share system clipboard
vim.opt.clipboard = "unnamedplus"

--- scrolloffset
vim.opt.scrolloff = 999

--- visual block mode
--- allows for visual blocks to expand past
--- the end of their lines
vim.opt.virtualedit = "block"

--- show incremental changes (i.e replacements) in a split
vim.opt.inccommand = "split"

--- case insensitive command search
vim.opt.ignorecase = true

--- use nice colors from modern terminals
vim.opt.termguicolors = true

--- leader key
vim.g.mapleader = " "

--- Use ripgrep
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

--- autoread changes
vim.opt.autoread = true

--- undo
vim.o.undofile = true
vim.o.shortmess = "at"

--- I know what mode I'm in
vim.opt.showmode = false

--- folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- Gitsigns

require("gitsigns").setup({
  current_line_blame = true
})

-- Blink
require("blink.cmp").setup({
  keymap = { preset = 'super-tab' },
  appearance = {
    nerd_font_variant = 'mono'
  },
  completion = { documentation = { auto_show = true, window = { border = "rounded" } } },
  sources = {
    -- Add 'avante' to the list
    default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      avante = {
        module = 'blink-cmp-avante',
        name = 'Avante'
      }
    },
  },
  cmdline = {
    keymap = { preset = 'super-tab' },
    completion = { menu = { auto_show = true } }
  },
  fuzzy = { implementation = "prefer_rust_with_warning" }
})

-- visual multi

-- require("vim-visual-multi").setup({})

-- treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "erlang", "elixir", "rust", "javascript", "typescript", "markdown" },

  auto_install = true,

  highlight = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = false,
      scope_incremental = false,
      node_incremental = "v",
      node_decremental = "V",
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {},
      selection_modes = {},
      include_surrounding_whitespace = true,
    },
  },
})


-- treewalker
require("treewalker").setup({
  highlight = true,

  -- How long should above highlight last (in ms)
  highlight_duration = 250,

  -- The color of the above highlight. Must be a valid vim highlight group.
  -- (see :h highlight-group for options)
  highlight_group = 'ColorColumn',
})

-- inline diagnostics
vim.diagnostic.config({ virtual_text = false })
require('tiny-inline-diagnostic').setup()

-- render markdown
require("render-markdown").setup({
  file_types = { "markdown", "Avante" },
  bullet = {
    -- cleaner bullet points
    icons = { "•", "∙" },
  },
  heading = {
    -- Icons that say H1, H2, etc.
    icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
  },
})

-- Conform

require('conform').setup({
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
    local is_global = not args.bang
    if is_global then
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      if vim.g.disable_autoformat then
        vim.notify("Autoformat-on-save disabled globally", "info", { title = "conform.nvim" })
      else
        vim.notify("Autoformat-on-save enabled globally", "info", { title = "conform.nvim" })
      end
    else
      vim.b.disable_autoformat = not vim.b.disable_autoformat
      if vim.b.disable_autoformat then
        vim.notify("Autoformat-on-save disabled for this buffer", "info", { title = "conform.nvim" })
      else
        vim.notify("Autoformat-on-save enabled for this buffer", "info", { title = "conform.nvim" })
      end
    end
  end,
  {
    desc = "Toggle autoformat-on-save",
    bang = true,
  })

-- Mason/LSP

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "expert" },
  automatic_enable = true
})

require("lsp_signature").setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  }
})

-- Mini

local minifiles = require("mini.files")
local minimove = require("mini.move")

require("mini.statusline").setup({})

require("mini.files").setup({})
require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = 'H',
    right = 'L',
    down = 'J',
    up = 'K',
  }
})

-- Snacks
require("snacks").setup({
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
  }
})

-- Neogit
require("neogit").setup({})

-- Nvim Surround
require("nvim-surround").setup({
  -- Configuration here, or leave empty to use defaults
  --
  surrounds = {
    ["%"] = {
      add = function()
        return { { "%{" }, { "}" } }
      end,
    }
  }
})

-- tmux navigation
--
require("nvim-tmux-navigation").setup({
  disable_when_zoomed = true, -- defaults to false
})

-- Colorizer

require('colorizer').setup({
  '*',
  html = {
    mode = 'foreground'
  }
})

-- Quicker

require("bqf").setup({})
require("quicker").setup({})

-- Avante
require("img-clip").setup({
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = {
      insert_mode = true,
    }
  }
})

require("avante_lib").load()
require("avante").setup({
  provider = "claude",
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-20250514",
      timeout = 30000, -- Timeout in milliseconds
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    }
  }
})


-- Keymap
require("which-key").add({
  mode = { "n", "v" },
  { "<leader>a", group = "ai" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "file" },
  { "<leader>g", group = "git" },
  { "<leader>h", group = "share" },
  { "<leader>q", group = "quit" },
  { "<leader>n", group = "notifications" },
  { "<leader>s", group = "search" },
  { "<leader>o", group = "open",         icon = "|>" },
  { "<leader>t", group = "terminal" },
  { "<leader>b", group = "buffer" },
  { "<leader>w", group = "window" },
  { "<leader>x", group = "debug" }
})

-- Don't yank when pasting

vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>xx", function()
  require("quicker").toggle()
end, { desc = "Toggle Quickfix" })

vim.keymap.set("n", "<leader>xc", function()
  require("quicker").close()
end, { desc = "Close Quickfix" })

vim.keymap.set("n", ">", function()
  require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
  vim.api.nvim_win_set_height(0, math.min(25, vim.api.nvim_buf_line_count(0)))
end, { desc = "Expand quickfix context" })

vim.keymap.set("n", "<", function()
  require("quicker").collapse()
end, { desc = "Collapse quickfix context" })

-- Windows

vim.keymap.set("n", "<leader>wv", function()
  vim.cmd("vsplit")
end, { desc = "Vertical split" })

vim.keymap.set("n", "<leader>wh", function()
  vim.cmd("split")
end, { desc = "Horizontal split" })

vim.keymap.set("n", "<leader>ww", function()
  vim.cmd("wincmd w")
end, { desc = "Next window" })

vim.keymap.set("n", "<leader>wn", function()
  local current_file = vim.fn.expand("%:p:h")
  local new_file = current_file .. "/untitled"
  vim.cmd("new " .. new_file)
end, { desc = "New window" })

vim.keymap.set("n", "<leader>wc", function()
  vim.cmd("close")
end, { desc = "Close window" })

-- Open

vim.keymap.set("n", "<leader>od", function()
  require("snacks").dashboard()
end, { desc = "Open Dashboard" })


vim.keymap.set("n", "<leader>bc", function()
  vim.cmd("bd")
end, { desc = "Close buffer" })

vim.keymap.set("n", "<leader>bf", function()
  require("snacks").picker.buffers()
end, { desc = "Find buffers" })

-- Quit

vim.keymap.set("n", "<leader>qq", function()
  vim.cmd("confirm quitall")
end, { desc = "Quit neovim" })

vim.keymap.set("n", "<leader>qh", function()
  vim.cmd("noh")
end, { desc = "Dismiss highlights" })

-- Files
vim.keymap.set('n', '<leader>fd', function()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand "%")
    require("snacks").bufdelete({ force = true })
  end
end, { desc = "Delete current file" })
vim.keymap.set('n', '<leader>fv', '<cmd>:vnew<cr>', { desc = "Create a new file in a vertical split" })
vim.keymap.set('n', '<leader>fh', '<cmd>:new<cr>', { desc = "Create a new file in a horizontal split" })

vim.keymap.set("n", "<leader>ft", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  minifiles.open(path)
  minifiles.reveal_cwd()
end, { desc = "Open Mini Files" })

-- undotree

vim.keymap.set("n", "<leader>ou", function()
  vim.cmd("UndotreeToggle")
end, { desc = "Open Undotree" })

-- navigation

-- stay in visual mode as indenting/outdenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set('n', '<leader>?', function()
    require("which-key").show({ global = false })
  end,
  { desc = "Buffer local keymaps" }
)

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

vim.keymap.set("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", require("nvim-tmux-navigation").NvimTmuxNavigateLastActive)
vim.keymap.set("n", "<C-Space>", require("nvim-tmux-navigation").NvimTmuxNavigateNext)

-- neogit

vim.keymap.set("n", "<leader>gg", function()
  require("neogit").open()
end, { desc = "Open Neogit" })

vim.keymap.set("n", "<leader>gv", function()
  require("neogit").open({ kind = "split" })
end, { desc = "Open Neogit" })

vim.keymap.set("n", "<leader>gv", function()
  require("neogit").open({ kind = "vsplit" })
end, { desc = "Open Neogit" })

-- snacks
vim.keymap.set("n", "<leader>.", function() require("snacks").scratch() end, { desc = "Open persistent scratch" })

vim.keymap.set("n", "<leader>fs", function()
  if vim.tbl_isempty(require("snacks").scratch.list()) then
    require("snacks").scratch()
  else
    require("snacks").scratch.select()
  end
end, { desc = "Find scratch" })

vim.keymap.set("n", "<leader>fn", function()
  require("snacks").notifier.show_history()
end, { desc = "Find notification" })

vim.keymap.set("n", "<leader>ff", function()
  require("snacks").picker.files({ hidden = true })
end, { desc = "Find file" })

vim.keymap.set("n", "<leader><leader>", function() require("snacks").picker.commands() end, { desc = "Commands" })

vim.keymap.set("n", "<leader>nn", function() require("snacks").picker.notifications() end,
  { desc = "Notification History" })

vim.keymap.set("n", "<leader>ss", function()
  require("snacks").picker.grep({ hidden = true })
end, { desc = "Search all files" })

-- Autocmds
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

--- Autoread files when they change on the filesystem
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})

--- Always start at the top of git commit messages
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "NeogitCommitMessage" },
  callback = function()
    vim.defer_fn(function()
      vim.cmd("normal! gg")
      vim.cmd("startinsert!")
    end, 50)
  end,
})

--- Build Avante from source when plugin is changed
vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(event)
    if event.data.spec and event.data.spec.name == "avante.nvim" then
      -- Try multiple possible paths
      local possible_paths = {
        vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", "avante.nvim"),
        vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "deps", "start", "avante.nvim"),
        vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "deps", "opt", "avante.nvim"),
      }
      
      local plugin_path = nil
      for _, path in ipairs(possible_paths) do
        if vim.fn.isdirectory(path) == 1 then
          plugin_path = path
          break
        end
      end
      
      if not plugin_path then
        vim.notify("Avante plugin directory not found during PackChanged. Checked: " .. vim.inspect(possible_paths), vim.log.levels.ERROR)
        return
      end
      
      vim.notify("Building Avante from source at: " .. plugin_path, vim.log.levels.INFO)
      
      -- Set up environment for building from source
      local env = vim.fn.environ()
      env.BUILD_FROM_SOURCE = "true"
      
      vim.fn.jobstart({"make", "BUILD_FROM_SOURCE=true"}, {
        cwd = plugin_path,
        env = env,
        on_stdout = function(_, data)
          if data and #data > 0 and data[1] ~= "" then
            vim.notify("Build output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 0 and data[1] ~= "" then
            vim.notify("Build stderr: " .. table.concat(data, "\n"), vim.log.levels.WARN)
          end
        end,
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("Avante build completed successfully! Restart Neovim to use the updated plugin.", vim.log.levels.INFO)
          else
            vim.notify("Avante build failed with exit code: " .. exit_code, vim.log.levels.ERROR)
          end
        end,
      })
    end
  end,
})

-- Manual command to build Avante
vim.api.nvim_create_user_command("AvanteBuild", function()
  -- Try multiple possible paths
  local possible_paths = {
    vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", "avante.nvim"),
    vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "deps", "start", "avante.nvim"),
    vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "deps", "opt", "avante.nvim"),
  }
  
  local plugin_path = nil
  for _, path in ipairs(possible_paths) do
    if vim.fn.isdirectory(path) == 1 then
      plugin_path = path
      break
    end
  end
  
  if not plugin_path then
    vim.notify("Avante plugin directory not found. Checked: " .. vim.inspect(possible_paths), vim.log.levels.ERROR)
    return
  end
  
  vim.notify("Building Avante from source at: " .. plugin_path, vim.log.levels.INFO)
  
  local env = vim.fn.environ()
  env.BUILD_FROM_SOURCE = "true"
  
  vim.fn.jobstart({"make", "BUILD_FROM_SOURCE=true"}, {
    cwd = plugin_path,
    env = env,
    on_stdout = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("Build output: " .. table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("Build stderr: " .. table.concat(data, "\n"), vim.log.levels.WARN)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Avante build completed successfully! Restart Neovim to use the updated plugin.", vim.log.levels.INFO)
      else
        vim.notify("Avante build failed with exit code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Build Avante from source manually" })

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
      vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})
