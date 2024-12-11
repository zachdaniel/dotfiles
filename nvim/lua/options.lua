-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- preferred location for splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- don't do line wrapping
vim.opt.wrap = false

-- use spaces instead of tabs
default_tab_size = 2

vim.opt.expandtab = true
vim.opt.tabstop = default_tab_size
vim.opt.shiftwidth = default_tab_size

-- share system clipboard
vim.opt.clipboard = "unnamedplus"

-- scrolloffset
-- vim.opt.scrolloff = 999

-- visual block mode
-- allows for visual blocks to expand past
-- the end of their lines
vim.opt.virtualedit = "block"

-- show incremental changes (i.e replacements) in a split
vim.opt.inccommand = "split"

-- case insensitive command search
vim.opt.ignorecase = true

-- use nice colors from modern terminals
vim.opt.termguicolors = true

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"