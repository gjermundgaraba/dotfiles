local multi_keymaps = require 'utils.multi_keymaps'

-- clear search results
multi_keymaps.add('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
end)

-- TODO: Add keymap for CTRL+J/K (maybe the rest to go back and forth in insert mode)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cdq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>cdn', vim.diagnostic.goto_next, { desc = 'Go to [N]ext [D]iagnostics message' })
vim.keymap.set('n', '<cleader>cdp', vim.diagnostic.goto_prev, { desc = 'Go to [P]revious [D]iagnostics message' })

-- Keybindings to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
