-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'folke/persistence.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>fE',
      function()
        require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    { '<leader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
    {
      '<leader>ge',
      function()
        require('neo-tree.command').execute { source = 'git_status', toggle = true }
      end,
      desc = 'Git Explorer',
    },
    {
      '<leader>be',
      function()
        require('neo-tree.command').execute { source = 'buffers', toggle = true }
      end,
      desc = 'Buffer Explorer',
    },
  },
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  config = function()
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            '.git',
            '.DS_Store',
            'thumbs.db',
            '.idea',
          },
          never_show = {},
        },
      },
      window = {
        mappings = {
          ['l'] = 'open',
          ['h'] = 'close_node',
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            unstaged = '󰄱',
            staged = '󰱒',
          },
        },
      },
    }
  end,

  -- opts = {
  --   sources = { 'filesystem', 'buffers', 'git_status' },
  --   open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
  --   filesystem = {
  --     bind_to_cwd = false,
  --     follow_current_file = { enabled = true },
  --     use_libuv_file_watcher = true,
  --   },
  --   window = {
  --     mappings = {
  --       ['l'] = 'open',
  --       ['h'] = 'close_node',
  --       ['<space>'] = 'none',
  --       ['Y'] = {
  --         function(state)
  --           local node = state.tree:get_node()
  --           local path = node:get_id()
  --           vim.fn.setreg('+', path, 'c')
  --         end,
  --         desc = 'Copy Path to Clipboard',
  --       },
  --       ['O'] = {
  --         function(state)
  --           require('lazy.util').open(state.tree:get_node().path, { system = true })
  --         end,
  --         desc = 'Open with System Application',
  --       },
  --       ['P'] = { 'toggle_preview', config = { use_float = false } },
  --     },
  --   },
  --   default_component_configs = {
  --     indent = {
  --       with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
  --       expander_collapsed = '',
  --       expander_expanded = '',
  --       expander_highlight = 'NeoTreeExpander',
  --     },
  --     git_status = {
  --       symbols = {
  --         unstaged = '󰄱',
  --         staged = '󰱒',
  --       },
  --     },
  --   },
  -- },
}
