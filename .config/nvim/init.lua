require "config.options"
require "config.keymaps"
require "config.autocmds"
require "config.lsp"
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

---@type LazySpec
local plugins = "plugins"

-- Configure plugins.
require("lazy").setup(plugins, {
  ui = { border = "rounded" },
  install = {
    missing = true,
  },
  -- Don't bother me when tweaking plugins.
  change_detection = { notify = false },
  -- None of my plugins use luarocks so disable this.
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        "gzip",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
