return {
  'rhysd/git-messenger.vim',
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = {
          ours = '<leader>gco',
          theirs = '<leader>gct',
          none = '<leader>gcn',
          both = '<leader>gcb',
          next = '<leader>gj',
          prev = '<leader>gk',
        },
      }
    end,
  },
  'sindrets/diffview.nvim',
}
