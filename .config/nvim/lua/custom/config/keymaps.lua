local multi_keymaps = require 'custom.utils.multi_keymaps'

-- clear search restults
multi_keymaps.add('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
end)

-- TODO: Add keymap for CTRL+J/K (maybe the rest to go back and forth in insert mode)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
--vim.keymap.set('n', '<leader>cf', vim.
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostics message' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostics message' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set({ 'n', 'i', 't' }, '<D-h>', '<Home>')
vim.keymap.set({ 'n', 'i', 't' }, '<D-l>', '<End>')
vim.keymap.set({ 'i', 't' }, '<M-D-h>', '<C-o>b')
vim.keymap.set('n', '<M-D-h>', 'b')
vim.keymap.set({ 'i', 't' }, '<M-D-l>', '<C-o>w')
vim.keymap.set('n', '<M-D-l>', 'w')
vim.keymap.set({ 'i', 't' }, '˛', '<left>')
vim.keymap.set({ 'i', 't' }, '√', '<down>')
vim.keymap.set({ 'i', 't' }, 'ª', '<up>')
vim.keymap.set({ 'i', 't' }, 'ﬁ', '<right>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
