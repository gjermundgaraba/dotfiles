-- NOTE: We load this before plugins, so this should only contain basic vim options.

-- Set <space> as the leader key  WARN: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.opt` and `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Show the mode, since we currently have no status bar plugin
vim.opt.showmode = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Tab spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.bo.softtabstop = 4

-- Spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = false -- we can turn this on for specific file types in autocmds.lua

vim.diagnostic.config {
  -- Use the default configuration
  virtual_lines = true,
}

-- Folding.
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Default is something like: vim.o.statuscolumn = "%C%s%l "
vim.o.statuscolumn = '%=%s%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "↓" : "→") : " ") : " " } %l '

-- NOTE: The folding characters are not used in the status column when defined like above.
-- Folding characters.
-- vim.opt.fillchars = {
--   eob = " ",
--   fold = " ",
--   foldclose = "→",
--   foldopen = "↓",
--   foldsep = " ",
--   msgsep = "─",
-- }

-- NOTE: Currently not used
-- LSP Options
-- vim.cmd [[set completeopt+=menuone,noselect,popup]]

-- Optimizations
vim.opt.maxmempattern = 102400
