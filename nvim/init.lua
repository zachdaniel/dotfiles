-- diffs.nvim reads vim.g.diffs at load time, so this must precede vim.pack.add
vim.g.diffs = {
  integrations = {
    neogit = true,
    gitsigns = true,
  },
}

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/romus204/tree-sitter-manager.nvim",
  "https://github.com/aaronik/treewalker.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/santhosh-tekuri/wordiff.nvim",
  -- "https://github.com/sindrets/diffview.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/catppuccin/nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/flash.nvim",
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
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
  "https://github.com/barrettruth/diffs.nvim",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/gregorias/nvim-surround-wk",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/HakonHarnes/img-clip.nvim",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/adriankarlen/plugin-view.nvim",
  "https://github.com/Owen-Dechow/videre.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/folke/sidekick.nvim",
  "https://github.com/pmizio/typescript-tools.nvim",
  "https://github.com/jim-at-jibba/nvim-redraft",
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
  flavour = "mocha",
  transparent_background = true,
})

require('lualine').setup {
  options = {
    theme = "catppuccin-mocha",
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
vim.cmd.colorscheme "catppuccin-mocha"

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

--- keep the cursor centered even at the end of the buffer
--- (scrolloff alone won't pad past the last line)
vim.opt.scrolloffpad = 1

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

vim.opt.cmdheight = 2

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
vim.opt.winborder = "rounded"

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

require("blink.cmp").setup({
  keymap = {
    preset = "super-tab",
    ["<Tab>"] = {
      function(cmp) -- prefer blink/LSP completions when menu is visible
        if cmp.is_visible() then
          return cmp.accept({ select = true })
        end
      end,
      "snippet_forward",
      function() -- sidekick NES as fallback when no LSP completions
        return require("sidekick").nes_jump_or_apply()
      end,
      function() -- native inline completions as fallback
        return vim.lsp.inline_completion.get()
      end,
      "fallback",
    },
    ["<S-Tab>"] = { -- force-accept sidekick/copilot even when LSP menu is open
      function()
        return require("sidekick").nes_jump_or_apply()
      end,
      function()
        return vim.lsp.inline_completion.get()
      end,
      "select_prev",
      "snippet_backward",
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
    },
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
vim.g._ts_force_sync_parsing = true
require("tree-sitter-manager").setup({
  ensure_installed = { "lua", "elixir", "heex", "eex", "typescript", "tsx", "javascript", "json", "markdown", "markdown_inline", "css", "html", "bash", "regex", "vim", "vimdoc", "diff" },
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Treesitter selection, multicursor-friendly (:h multicursor)
--
-- Lua inside a mapping runs once, at the primary cursor; the cascade replays the
-- resolved keys at the extra cursors, and a Lua-driven Visual selection voids the
-- replay. A normal-mode `v` mapping therefore broke *every* Visual sequence at the
-- extra cursors (even `viw`), so `v` is plain Visual again and treesitter comes in
-- two forms that do work:
--   * Text objects `an` / `in` with an operator: `can`, `d2an`, `yin`, and `.`.
--     Lua text objects are re-run at each cursor. `[count]` climbs parents;
--     `in` strips bracketing delimiters. (`van` still only selects at the primary.)
--   * In Visual mode `v` grows the selection to the enclosing node and `V`
--     shrinks it back (plain `V` when there is nothing to shrink). `v v` selects
--     the node under the cursor.
do
  local history = {} ---@type table<string, {number, number, number, number}>

  local function line_len(row) return #vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] end

  --- Node range as 0-indexed, end-inclusive {sr, sc, er, ec}.
  local function node_range(node)
    local sr, sc, er, ec = node:range()
    if ec == 0 and er > sr then er = er - 1; ec = line_len(er) end
    return { sr, sc, er, math.max(ec - 1, 0) }
  end

  --- Current Visual range as 0-indexed, end-inclusive.
  local function visual_range()
    local v, c = vim.fn.getpos("v"), vim.fn.getpos(".")
    local s, e = v, c
    if c[2] < v[2] or (c[2] == v[2] and c[3] < v[3]) then s, e = c, v end
    return { s[2] - 1, s[3] - 1, e[2] - 1, e[3] - 1 }
  end

  local function key(r) return table.concat(r, ":") end
  local function before(r1, c1, r2, c2) return r1 < r2 or (r1 == r2 and c1 <= c2) end
  local function contains(o, i) return before(o[1], o[2], i[1], i[2]) and before(i[3], i[4], o[3], o[4]) end

  --- Smallest node whose range strictly contains `range`.
  local function enclosing_node(range)
    local ok, node = pcall(vim.treesitter.get_node, { pos = { range[1], range[2] } })
    if not ok then return nil end
    while node do
      local nr = node_range(node)
      if contains(nr, range) and key(nr) ~= key(range) then return node end
      node = node:parent()
    end
  end

  --- Select an end-inclusive range charwise, from Normal or Visual mode.
  local function select(r)
    local in_visual = vim.fn.mode():match("^[vV\22]") ~= nil
    vim.api.nvim_win_set_cursor(0, { r[1] + 1, r[2] })
    vim.cmd(in_visual and "normal! o" or "normal! v")
    vim.api.nvim_win_set_cursor(0, { r[3] + 1, r[4] })
  end

  vim.keymap.set("x", "v", function()
    local cur = visual_range()
    local node = enclosing_node(cur)
    if not node then return end
    local r = node_range(node)
    history[key(r)] = cur
    select(r)
  end, { desc = "Grow selection to enclosing treesitter node" })

  vim.keymap.set("x", "V", function()
    local r = history[key(visual_range())]
    if r then select(r) else vim.cmd("normal! V") end
  end, { desc = "Shrink selection (linewise Visual when nothing to shrink)" })

  local function node_at_cursor(levels)
    local ok, node = pcall(vim.treesitter.get_node)
    if not ok or not node then return nil end
    for _ = 2, levels do node = node:parent() or node end
    return node
  end

  --- Select [sr, sc] .. [er, ec) (0-indexed, end-exclusive).
  local function select_exclusive(sr, sc, er, ec)
    if sc >= line_len(sr) and er > sr then sr, sc = sr + 1, 0 end -- starts past EOL: next line
    if ec == 0 and er > sr then er = er - 1; ec = line_len(er) end -- ends at BOL: previous EOL
    if sr > er then return end
    select({ sr, sc, er, math.max(ec - 1, 0) })
  end

  vim.keymap.set({ "o", "x" }, "an", function()
    local node = node_at_cursor(vim.v.count1)
    if node then select_exclusive(node:range()) end
  end, { desc = "Treesitter node ([count] climbs parents)" })

  vim.keymap.set({ "o", "x" }, "in", function()
    local node = node_at_cursor(vim.v.count1)
    if not node then return end
    local first, last = node:child(0), node:child(node:child_count() - 1)
    -- Strip anonymous delimiters like ( ) { } [ ] when they bracket the node.
    if first and last and first ~= last and not first:named() and not last:named() then
      local _, _, sr, sc = first:range()
      local er, ec = last:range()
      if sr < er or (sr == er and sc < ec) then return select_exclusive(sr, sc, er, ec) end
    end
    select_exclusive(node:range())
  end, { desc = "Inside treesitter node ([count] climbs parents)" })
end

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
  enabled = false,
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

-- Typescript
require("typescript-tools").setup({})

-- Redraft
require("nvim-redraft").setup({
  llm = {
    provider = "anthropic",
    model = "claude-opus-4-20250514",
  },
  diff_mode = true,
})

-- Sidekick
-- copilot LSP removed: hit "completions limit reached" on Copilot free tier.
-- vim.lsp.enable("copilot")

require("sidekick").setup({
  nes = { enabled = false }, -- NES disabled: relied on the copilot LSP above
  cli = {
    mux = {
      backend = "tmux",
      enabled = true
    },
    win = {
      keys = {
        shift_enter = {
          "<S-CR>",
          function(self)
            if self:is_running() then
              vim.api.nvim_chan_send(vim.b[self.buf].terminal_job_id, "\x1b[13;2u")
            end
          end,
          desc = "Shift+Enter (newline without submit)"
        },
      },
    },
  }
});

-- Videre
require('videre').setup {
  box_style = "rounded"
}

-- Conform

require("conform").setup({
  formatters_by_ft = {
    typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
    json = { "biome", "prettierd", "prettier", stop_after_first = true },
    jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
    css = { "biome", "prettierd", "prettier", stop_after_first = true },
  },
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
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value or {}
    local msg = value.message or "done"
    -- rust analyszer in particular has really long LSP messages so truncate them
    if #msg > 40 then
      msg = msg:sub(1, 37) .. "..."
    end

    -- :h LspProgress
    vim.api.nvim_echo({ { msg } }, false, {
      source = "lsp",
      id = "lsp",
      kind = "progress",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "expert" },
  -- copilot excluded: it's still installed in mason, and automatic_enable would
  -- otherwise auto-start it (the "completions limit reached" source). Remove this
  -- exclude (or :MasonUninstall copilot-language-server) to bring it back.
  automatic_enable = { exclude = { "copilot" } }
})

require("lsp_signature").setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  }
})

vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  root_markers = { 'mix.exs', '.git' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
})

vim.lsp.enable 'expert'

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- Mini

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

-- Which-key
-- Built-in plugins/presets cover what mini.clue's gen_clues did:
-- g/z/window/bracket clues via presets, marks (' and `), registers
-- (" in n/x, <C-r> in i/c), plus spelling (z=).
require("which-key").setup({
  preset = "modern",
  delay = 200,
  win = { border = "rounded" },
  triggers = {
    { "<auto>", mode = "nxso" },
    -- built-in completion clues, like mini.clue's gen_clues.builtin_completion()
    { "<C-x>",  mode = "i" },
  },
  spec = {
    {
      mode = { "n", "v" },
      { "<leader>a", group = "ai" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "share" },
      { "<leader>n", group = "notifications" },
      { "<leader>o", group = "open" },
      { "<leader>q", group = "quit" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "terminal" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "debug" },
    },
    {
      mode = "n",
      -- builtin multicursor (:h multicursor), descriptions only
      { "Q",      desc = "Toggle multicursor ([count]Q: every search match)" },
      { "gQ",     desc = "Restore multicursors" },
      { "q=",     desc = "Toggle multicursor follow-mode" },
      { "]C",     desc = "Next multicursor" },
      { "[C",     desc = "Previous multicursor" },
      { "g<C-a>", desc = "Multicursor counter (1, 2, 3, …)" },
    },
    { mode = "x", { "Q", desc = "Multicursor on each selected line" } },
    {
      mode = "i",
      { "<C-x><C-l>", desc = "Whole lines" },
      { "<C-x><C-n>", desc = "Keywords in current file" },
      { "<C-x><C-k>", desc = "Keywords in 'dictionary'" },
      { "<C-x><C-t>", desc = "Keywords in 'thesaurus'" },
      { "<C-x><C-i>", desc = "Keywords in included files" },
      { "<C-x><C-]>", desc = "Tags" },
      { "<C-x><C-f>", desc = "File names" },
      { "<C-x><C-d>", desc = "Definitions or macros" },
      { "<C-x><C-v>", desc = "Vim command line" },
      { "<C-x><C-u>", desc = "User defined completion" },
      { "<C-x><C-o>", desc = "Omni completion" },
      { "<C-x><C-s>", desc = "Spelling suggestions" },
    },
  },
})

-- Snacks
require("snacks").setup({
  dashboard = {
    enabled = false,
    sections = {
      { section = "header" },
      { section = "keys",  gap = 1, padding = 1 },
    }
  },
  indent = {},
  picker = {
    matcher = {
      frecency = true
    }
  },
  notifier = { enabled = true },
  image = {},
  terminal = {},
})

-- Neogit
require("neogit").setup({
  prompt_force_push = false, -- never offer force push on a rejected push (no accidental disasters)
})

-- Nvim Surround
require("nvim-surround").setup({
  -- Configuration here, or leave empty to use defaults
  --
  surrounds = {
    ["%"] = {
      add = function()
        return { { "%{" }, { "}" } }
      end,
      -- labels are required for nvim-surround-wk's which-key hints
      label = "%{…}",
    }
  }
})

-- Which-key hints for nvim-surround; must run after both are set up
require("nvim-surround-wk").setup()


-- Quicker

require("bqf").setup({})
require("quicker").setup({})
require("plugin-view").setup()

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
vim.keymap.set("n", "<leader>fc", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })
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

-- Multicursor (builtin, :h multicursor)
-- Q toggles a cursor, [count]Q places one on every search match, {Visual}Q one
-- per line, q= toggles follow-mode, gQ restores, ]C/[C jump between cursors.
-- The default clear key <C-L> is taken by Ghostty navigation below, so use <Esc>.
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
end, { desc = "Clear multicursors and search highlight" })

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

-- Ghostty split navigation: navigate neovim windows, fall through to ghostty at edges
local function ghostty_navigate(direction)
  local ghostty_dir = ({ h = "left", j = "down", k = "up", l = "right" })[direction]
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  if vim.api.nvim_get_current_win() == win then
    vim.fn.jobstart({ "ghostty-nav", ghostty_dir }, { detach = true })
  end
end
vim.keymap.set("n", "<C-h>", function() ghostty_navigate("h") end)
vim.keymap.set("n", "<C-j>", function() ghostty_navigate("j") end)
vim.keymap.set("n", "<C-k>", function() ghostty_navigate("k") end)
vim.keymap.set("n", "<C-l>", function() ghostty_navigate("l") end)

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
vim.keymap.set("n", "<tab>", function()
  if not require("sidekick").nes_jump_or_apply() then
    return "<Tab>"
  end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "v" }, "<c-.>", function()
  require("sidekick.cli").focus()
end, { desc = "Sidekick Switch Focus" })

vim.keymap.set({ "n", "v" }, "<leader>aa", function()
  require("sidekick.cli").toggle({ focus = true })
end, { desc = "Sidekick Toggle CLI" })

vim.keymap.set({ "n", "v", "x", "t" }, "<leader>ac", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Claude Toggle" })

vim.keymap.set({ "n", "v" }, "<leader>ap", function()
  require("sidekick.cli").select_prompt()
end, { desc = "Sidekick Ask Prompt" })


-- redraft
vim.keymap.set("v", "<leader>ae", function() require("nvim-redraft").edit() end, { desc = "AI Edit Selection" })
vim.keymap.set("n", "<leader>am", function() require("nvim-redraft").select_model() end, { desc = "Select AI Model" })

-- snacks terminal
vim.keymap.set("n", "<leader>tt", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>tf", function() Snacks.terminal(nil, { win = { style = "terminal" } }) end,
  { desc = "Toggle Floating Terminal" })

-- snacks
vim.keymap.set("n", "<leader>.", function() require("snacks").scratch() end, { desc = "Open persistent scratch" })

vim.keymap.set("n", "<leader>fs", function()
  require("snacks").picker.scratch()
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

-- Create Plugins command
vim.api.nvim_create_user_command("Plugins", function()
  require("plugin-view").open()
end, { desc = "Open plugin view" })

-- Autocmds

--- Autoread files when they change on the filesystem
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.bo.buftype ~= "terminal" then
      vim.cmd("checktime")
    end
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

--- Wrap markdown, breaking at word boundaries
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
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
  desc = "Build nvim-redraft after install/update",
  group = vim.api.nvim_create_augroup("nvim-redraft-build", { clear = true }),
  callback = function(event)
    if event.data.spec.name == "nvim-redraft" then
      local dir = event.data.spec.path .. "/ts"
      vim.notify("nvim-redraft: building TypeScript...", vim.log.levels.INFO)
      vim.system({ "npm", "install" }, { cwd = dir }):wait()
      vim.system({ "npm", "run", "build" }, { cwd = dir }):wait()
      vim.notify("nvim-redraft: build complete!", vim.log.levels.INFO)
    end
  end,
})
