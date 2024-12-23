return {
  {
    'ray-x/guihua.lua',
    build = 'cd lua/fzy && make',
    module = true,
    config = function()
      require('guihua').setup {
        icons = {
          syntax = {
            namespace = '',
          },
        },
      }
      vim.ui.select = require('guihua.gui').select
      vim.ui.input = require('guihua.gui').input
    end,
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup {
        run_in_floaterm = true,
      }
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
