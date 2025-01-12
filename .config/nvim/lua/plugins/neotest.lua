return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'fredrikaverpil/neotest-golang', version = '*' }, -- Installation
      'mrcjkb/rustaceanvim',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-golang' {
            testify_enabled = true,
            log_level = vim.log.levels.DEBUG,
          },
          require 'rustaceanvim.neotest',
        },
      }
    end,
    keys = {
      {
        '<leader>to',
        function()
          require('neotest').output_panel.open()
          require('neotest').summary.open()
        end,
        desc = 'Open test output',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test',
      },
      -- {
      --   '<leader>td',
      --   function()
      --     require('neotest').run.run { suite = false, strategy = 'dap' }
      --   end,
      --   desc = 'Debug nearest test',
      -- },
    },
  },
}
