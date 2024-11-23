return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'fredrikaverpil/neotest-golang', -- Installation
        version = '*',
        dependencies = {
          'leoluz/nvim-dap-go',
        },
      },
      {
        'mrcjkb/rustaceanvim',
        version = '^5', -- Recommended
        lazy = false, -- This plugin is already lazy
      },
    },
    -- TODO: Replace the user commands with functions when this plugin is moved into a separate file
    -- stylua: ignore
    keys = {
      { '<leader>tr', ':NTestRunWithOpenStuff<CR>', desc = 'Run the nearest test' },
      { '<leader>to', ':NTestOpenStuff<CR>', desc = 'Open test utilities' },
      { '<leader>tq', ':NTestCloseStuff<CR>', desc = 'Close test utilities' },
      { '<leader>td', ':NTestDebugWithOpenStuff<CR>', desc ="Debug nearest test" },
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to running test" },
    },
    opts = {
      -- See all config options with :h neotest.Config
      discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = true,
        -- Number of workers to parse files concurrently.
        -- A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 0,
      },
      running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = true,
      },
      summary = {
        -- Enable/disable animation of icons.
        animated = true,
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      icons = {
        child_indent = '│',
        child_prefix = '├',
        collapsed = '─',
        expanded = '╮',
        failed = '',
        final_child_indent = ' ',
        final_child_prefix = '╰',
        non_collapsible = '─',
        notify = '',
        passed = '',
        running = '',
        running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
        skipped = '',
        unknown = '',
        watching = '',
      },
    },
    config = function(_, opts)
      local neotest = require 'neotest'

      local neotestGolangConfig = {
        testify_enabled = true,
        runner = 'gotestsum',
      }
      opts.adapters = {
        require 'neotest-golang'(neotestGolangConfig), -- Registration
        require 'rustaceanvim.neotest',
      }
      neotest.setup(opts)

      vim.api.nvim_create_user_command('NTestRunWithOpenStuff', function()
        neotest.run.run()
        neotest.output_panel.open()
        neotest.summary.open()
      end, {})
      vim.api.nvim_create_user_command('NTestOpenStuff', function()
        neotest.output_panel.open()
        neotest.summary.open()
      end, {})
      vim.api.nvim_create_user_command('NTestCloseStuff', function()
        neotest.output_panel.close()
        neotest.summary.close()
      end, {})
      vim.api.nvim_create_user_command('NTestDebugWithOpenStuff', function()
        neotest.output_panel.open()
        neotest.summary.open()
        neotest.run.run { suite = false, strategy = 'dap' }
      end, {})
    end,
  },
}
