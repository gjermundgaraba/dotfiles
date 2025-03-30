-- require 'config.options'
-- require 'config.keymaps'
-- require 'config.autocmds'

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require('snacks.debug').inspect(...)
end
_G.bt = function(...)
  require('snacks.debug').backtrace()
end
_G.p = function(...)
  require('snacks.debug').profile(...)
end
vim.print = _G.dd

require 'config'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
