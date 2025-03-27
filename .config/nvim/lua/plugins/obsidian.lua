return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      'BufReadPre /Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain/**.md',
      'BufNewFile /Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain/**.md',
    },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      ui = {
        enable = false,
        checkboxes = {
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
        },
      },
      workspaces = {
        {
          name = 'gg-braind',
          path = '/Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain',
        },
      },
      templates = {
        folder = 'Templates',
        date_format = '%d-%m-%Y',
        time_format = '%H:%M',
      },
      note_id_func = function(title)
        return title
      end,
      callbacks = {
        post_setup = function()
          vim.opt.conceallevel = 1
        end,
      },
      mappings = {
        -- Smart action depending on context, either follow link or toggle checkbox.
        ['<cr>'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        -- Insert template
        ['<leader>it'] = {
          action = function()
            vim.cmd 'ObsidianTemplate'
          end,
        },
      },
    },
  },
}
