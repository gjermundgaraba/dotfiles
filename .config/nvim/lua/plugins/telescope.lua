-- Files, projects, etc

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = true },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            hidden = true,
          },
          lsp_references = {
            fname_width = 60,
          },
          lsp_implementations = {
            fname_width = 60,
          },
        },
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
          },
          file_ignore_patterns = {
            '.git/',
          },
          mappings = {
            i = {
              ['<C-h>'] = 'which_key', -- show keymaps inside a picker
            },
          },
        },
        extensions = {
          fzf = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'ui-select'

      local builtin = require 'telescope.builtin'
      local actions = require 'telescope.actions'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>sp', function()
        builtin.find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
        }
      end, { desc = '[S]earch neovim [P]lugin code files' })
      vim.keymap.set('n', '<leader>so', function()
        builtin.oldfiles {
          only_cwd = true,
        }
      end, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', function()
        require('telescope.builtin').buffers {
          attach_mappings = function(_, map)
            map('i', '<C-d>', actions.delete_buffer)
            map('n', '<C-d>', actions.delete_buffer)
            return true
          end,
          sort_mru = true,
        }
      end, { desc = '[ ] Find existing buffers' })
      vim.api.nvim_set_keymap('n', '<D-B>', ':bnext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<D-M-B>', ':bprev<CR>', { noremap = true, silent = true })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      require('utils.telescope-multigrep').setup()
    end,
  },
}
