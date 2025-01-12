-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('gg-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitConflictDetected',
  callback = function()
    vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
  end,
})

vim.api.nvim_create_augroup('Spellcheck', { clear = true })
-- Create an autocommand to enable spellcheck for specified file types
vim.api.nvim_create_autocmd('FileType', {
  group = 'Spellcheck', -- Grouping the command for easier management
  pattern = { 'text', 'markdown', 'gitcommit' }, -- Only apply to these file types
  callback = function()
    vim.opt_local.spell = true -- Enable spellcheck for these file types
  end,
  desc = 'Enable spellcheck for defined filetypes', -- Description for clarity
})
