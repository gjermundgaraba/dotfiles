vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Source current lua file' })
vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'Source current lua line' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Source selected lua lines' })
