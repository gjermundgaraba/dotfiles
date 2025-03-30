local multi_keymaps = require 'utils.multi_keymaps'

-- exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- save file
vim.keymap.set('n', '<D-s>', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- quit
vim.keymap.set('n', '<leader>q', ':qa<CR>', { desc = 'Quit' })

-- clear search results
multi_keymaps.add('n', '<Esc>', function()
  vim.cmd 'nohlsearch'
end)

vim.keymap.set('v', '<TAB>', '>gv', { desc = 'Indent selected text' })
vim.keymap.set('v', '<S-TAB>', '<gv', { desc = 'Indent selected text' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>cdq', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>cdn', function()
  vim.diagnostic.jump { diagnostic = vim.diagnostic.get_next() }
end, { desc = 'Go to [N]ext [D]iagnostics message' })
-- vim.keymap.set('n', '<cleader>cdp', function()
--   vim.diagnostic.jump { diagnostic = vim.diagnostic.get_prev() }
-- end, { desc = 'Go to [P]revious [D]iagnostics message' })

-- Keybindings to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- buffer stuff
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { silent = true })
