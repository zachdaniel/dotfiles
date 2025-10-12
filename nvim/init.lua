vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/aaronik/treewalker.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  -- "https://github.com/santhosh-tekuri/wordiff.nvim",
  -- "https://github.com/sindrets/diffview.nvim",
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
  "https://github.com/folke/snacks.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/norcalli/nvim-colorizer.lua",
  "https://github.com/alexghergh/nvim-tmux-navigation",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/adriankarlen/plugin-view.nvim",
  "https://github.com/Owen-Dechow/videre.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/sidekick.nvim",
  "https://github.com/saxon1964/neovim-tips",
  -- Optional: add YAML support
  -- "https://github.com/Owen-Dechow/graph_view_yaml_parser",
  -- Optional: add TOML support
  -- "https://github.com/Owen-Dechow/graph_view_toml_parser",
  -- Optional | Experimental: add XML support
  -- "https://github.com/a-usr/xml2lua.nvim",
})

vim.cmd "packadd nvim.difftool"
vim.cmd "packadd nvim.undotree"

require("catppuccin").setup({
  transparent_background = true
})

require('lualine').setup {
  options = {
    theme = "catppuccin",
  },
  sections = {
    lualine_c = {
      {
        function()
          return " "
        end,
        color = function()
          local status = require("sidekick.status").get()
          if status then
            return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
          end
        end,
        cond = function()
          local status = require("sidekick.status")
          return status.get() ~= nil
        end,
      } }
  }
}

-- Colorscheme
vim.cmd.colorscheme "catppuccin"

-- Basic Options
--- line numbers
vim.opt.number = true

--- preferred location for splits
vim.opt.splitbelow = true
vim.opt.splitright = true

--- don"t do line wrapping
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

--- I know what mode I"m in
vim.opt.showmode = false

--- folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- Gitsigns

require("gitsigns").setup({
  current_line_blame = true
})

-- LazyDev
require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

vim.lsp.inline_completion.enable()


-- Blink
-- want to do this but only if its not built already?
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.cmd("BlinkCmp build")
--   end,
--   once = true,
-- })
--
require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
    ["<Tab>"] = {
      "snippet_forward",
      function() -- sidekick next edit suggestion
        return require("sidekick").nes_jump_or_apply()
      end,
      function() -- if you are using Neovim's native inline completions
        return vim.lsp.inline_completion.get()
      end,
      "fallback",
    },
  },
  appearance = {
    nerd_font_variant = "mono"
  },
  completion = {
    menu = {
      border = "rounded"
    },
    documentation = {
      auto_show = true,
      window = { border = "rounded" }
    }
  },
  sources = {
    -- Add lazydev to the list
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      }
    },
  },
  cmdline = {
    keymap = { preset = "super-tab" },
    completion = { menu = { auto_show = true } }
  },
  fuzzy = { implementation = "prefer_rust_with_warning" }
})

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
  highlight_group = "ColorColumn",
})

-- inline diagnostics
vim.diagnostic.config({ virtual_text = false })
require("tiny-inline-diagnostic").setup()

-- render markdown
require("render-markdown").setup({
  file_types = { "markdown" },
  bullet = {
    -- cleaner bullet points
    icons = { "•", "∙" },
  },
  heading = {
    -- Icons that say H1, H2, etc.
    icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
  },
})

-- Sidekick
vim.lsp.enable("copilot")

require("sidekick").setup({
  cli = {
    mux = {
      backend = "tmux",
      enabled = true
    }
  }
});

-- Videre
require('videre').setup {
  round_units = false,
  simple_statusline = false,
  -- If you are just starting out with Videre,
  --   setting this to `false` will give you
  --   descriptions of available keymaps.
}

-- Conform

require("conform").setup({
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
  ensure_installed = { "lua_ls", "expert", "copilot" },
  automatic_enable = true
})

require("lsp_signature").setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  }
})

vim.lsp.config('expert', {
  flags = {
    allow_incremental_sync = false,
    -- When I set the below option to nil and have incremental sync on, I got substantial improvements with the fixes
    -- I had in place until a weird edge case popped up
    -- debounce_text_changes = nil
  }
})

-- Mini


-- require("mini.statusline").setup({})

require("mini.files").setup({})
require("mini.move").setup({
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "H",
    right = "L",
    down = "J",
    up = "K",
  }
})

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'v', keys = '<Leader>' },
    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },
    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    -- Window commands
    { mode = 'n', keys = '<C-w>' },
    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    -- Bracket keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },
  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    -- Leader group clues
    { mode = 'n', keys = '<Leader>a',  desc = '+ai' },
    { mode = 'v', keys = '<Leader>a',  desc = '+ai' },
    { mode = 'n', keys = '<Leader>c',  desc = '+code' },
    { mode = 'v', keys = '<Leader>c',  desc = '+code' },
    { mode = 'n', keys = '<Leader>f',  desc = '+file' },
    { mode = 'v', keys = '<Leader>f',  desc = '+file' },
    { mode = 'n', keys = '<Leader>g',  desc = '+git' },
    { mode = 'v', keys = '<Leader>g',  desc = '+git' },
    { mode = 'n', keys = '<Leader>h',  desc = '+share' },
    { mode = 'v', keys = '<Leader>h',  desc = '+share' },
    { mode = 'n', keys = '<Leader>q',  desc = '+quit' },
    { mode = 'v', keys = '<Leader>q',  desc = '+quit' },
    { mode = 'n', keys = '<Leader>n',  desc = '+notifications' },
    { mode = 'v', keys = '<Leader>n',  desc = '+notifications' },
    { mode = 'n', keys = '<Leader>s',  desc = '+search' },
    { mode = 'v', keys = '<Leader>s',  desc = '+search' },
    { mode = 'n', keys = '<Leader>o',  desc = '+open' },
    { mode = 'v', keys = '<Leader>o',  desc = '+open' },
    { mode = 'n', keys = '<Leader>t',  desc = '+terminal' },
    { mode = 'v', keys = '<Leader>t',  desc = '+terminal' },
    { mode = 'n', keys = '<Leader>b',  desc = '+buffer' },
    { mode = 'v', keys = '<Leader>b',  desc = '+buffer' },
    { mode = 'n', keys = '<Leader>w',  desc = '+window' },
    { mode = 'v', keys = '<Leader>w',  desc = '+window' },
    { mode = 'n', keys = '<Leader>x',  desc = '+debug' },
    { mode = 'v', keys = '<Leader>x',  desc = '+debug' },
    { mode = 'n', keys = '<Leader>nt', desc = '+neovim tips' },
    { mode = 'v', keys = '<Leader>nt', desc = '+neovim tips' },
  },
  window = {
    delay = 200,
    config = {
      width = 'auto',
    },
  },
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

require("colorizer").setup({
  "*",
  html = {
    mode = "foreground"
  }
})

-- Quicker

require("bqf").setup({})
require("quicker").setup({})
require("plugin-view").setup()

-- Neovim Tips
require("neovim_tips").setup({
  user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
  user_tip_prefix = "[User] ",
  warn_on_conflicts = true,
  daily_tip = 1,
})

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Don't yank when pasting

vim.keymap.set("v", "p", "'_dP", { noremap = true, silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>xx", function()
  require("quicker").toggle()
end, { desc = "Toggle Quickfix" })

vim.keymap.set("n", "<leader>xc", function()
  require("quicker").close()
end, { desc = "Close Quickfix" })

-- Set up quickfix-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", ">", function()
      require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      vim.api.nvim_win_set_height(0, math.min(25, vim.api.nvim_buf_line_count(0)))
    end, { desc = "Expand quickfix context", buffer = true })

    vim.keymap.set("n", "<", function()
      require("quicker").collapse()
    end, { desc = "Collapse quickfix context", buffer = true })
  end,
})

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
vim.keymap.set("n", "<leader>fd", function()
  local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

  if confirm == 1 then
    os.remove(vim.fn.expand "%")
    require("snacks").bufdelete({ force = true })
  end
end, { desc = "Delete current file" })
vim.keymap.set("n", "<leader>fv", "<cmd>:vnew<cr>", { desc = "Create a new file in a vertical split" })
vim.keymap.set("n", "<leader>fh", "<cmd>:new<cr>", { desc = "Create a new file in a horizontal split" })

vim.keymap.set("n", "<leader>ft", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  require("mini.files").open(path)
  require("mini.files").reveal_cwd()
end, { desc = "Open Mini Files" })

-- undotree

vim.keymap.set("n", "<leader>ou", function()
  vim.cmd("Undotree")
end, { desc = "Open Undotree" })

-- navigation

-- stay in visual mode as indenting/outdenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<leader>?", function()
    vim.cmd("help index")
  end,
  { desc = "Show help index" }
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

-- sidekick
vim.keymap.set({ "n", "i" }, "<tab>", function()
  -- if there is a next edit, jump to it, otherwise apply it if any
  if not require("sidekick").nes_jump_or_apply() then
    return "<Tab>" -- fallback to normal tab
  end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "v" }, "<c-.>", function()
  require("sidekick.cli").focus()
end, { desc = "Sidekick Switch Focus" })

vim.keymap.set({ "n", "v" }, "<leader>aa", function()
  require("sidekick.cli").toggle({ focus = true })
end, { desc = "Sidekick Toggle CLI" })

vim.keymap.set({ "n", "v" }, "<leader>ac", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Claude Toggle" })

vim.keymap.set({ "n", "v" }, "<leader>ap", function()
  require("sidekick.cli").select_prompt()
end, { desc = "Sidekick Ask Prompt" })

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

-- neovim tips
vim.keymap.set("n", "<leader>nto", "<cmd>NeovimTips<CR>", { desc = "Neovim tips" })
vim.keymap.set("n", "<leader>nte", "<cmd>NeovimTipsEdit<CR>", { desc = "Edit your Neovim tips" })
vim.keymap.set("n", "<leader>nta", "<cmd>NeovimTipsAdd<CR>", { desc = "Add your Neovim tip" })
vim.keymap.set("n", "<leader>nth", "<cmd>help neovim-tips<CR>", { desc = "Neovim tips help" })
vim.keymap.set("n", "<leader>ntr", "<cmd>NeovimTipsRandom<CR>", { desc = "Show random tip" })
vim.keymap.set("n", "<leader>ntp", "<cmd>NeovimTipsPdf<CR>", { desc = "Open Neovim tips PDF" })

-- Create Plugins command
vim.api.nvim_create_user_command("Plugins", function()
  require("plugin-view").open()
end, { desc = "Open plugin view" })

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

--- Make :w and :wq save mini.files buffers like pressing =
vim.api.nvim_create_autocmd("FileType", {
  pattern = "minifiles",
  callback = function(args)
    local bufnr = args.buf

    -- Set up buffer-local abbreviations for :w and :wq
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("cabbrev <buffer> w lua require('mini.files').synchronize()")
      vim.cmd("cabbrev <buffer> wq lua require('mini.files').synchronize(); require('mini.files').close()")
    end)
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})
