return {
  -- {
  --   'EdenEast/nightfox.nvim',
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd [[colorscheme nightfox]]
  --   end,
  -- },
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = {
      'folke/tokyonight.nvim',
      'rmehri01/onenord.nvim',
      'AlexvZyl/nordic.nvim',
      'shaunsingh/nord.nvim',
      'sainnhe/sonokai',
      'EdenEast/nightfox.nvim',
      { 'catppuccin/nvim', name = 'catppuccin' },
      'rafamadriz/neon',
      'shaunsingh/moonlight.nvim',
      'dgox16/oldworld.nvim',
      'olivercederborg/poimandres.nvim',
      'dracula/vim',
    },
    config = function()
      require('themery').setup {
        themes = {
          'tokyonight',
          'onenord',
          'nordic',
          'nord',
          'sonokai',
          'nightfox',
          'nordfox',
          'catppuccin',
          'catppuccin-frappe',
          'catppuccin-macchiato',
          'neon',
          'moonlight',
          'oldworld',
          'poimandres',
          'dracula',
        },
        livePreview = true,
      }
    end,
  },
  -- {
  --   'folke/edgy.nvim',
  --   event = 'VeryLazy',
  --   init = function()
  --     vim.opt.laststatus = 3
  --     vim.opt.splitkeep = 'screen'
  --   end,
  --   opts = {
  --     animate = {
  --       enabled = true,
  --       fps = 500,
  --       cps = 500,
  --     },
  --     left = {
  --       {
  --         title = 'Neo-Tree',
  --         ft = 'neo-tree',
  --         filter = function(buf)
  --           return vim.b[buf].neo_tree_source == 'filesystem'
  --         end,
  --         size = {
  --           height = 0.5,
  --           width = 0.15,
  --         },
  --       },
  --       {
  --         ft = 'neotest-summary',
  --         title = 'Neotest Summary',
  --         size = {
  --           height = 0.5,
  --           width = 0.15,
  --         },
  --       },
  --     },
  --     bottom = {
  --       {
  --         ft = 'toggleterm',
  --         title = 'Terminal',
  --         size = {
  --           height = 0.3,
  --         },
  --         -- exclude floating windows
  --         filter = function(buf, win)
  --           return vim.api.nvim_win_get_config(win).relative == ''
  --         end,
  --       },
  --       {
  --         ft = 'qf',
  --         title = 'QuickFix',
  --         size = {
  --           height = 0.3,
  --         },
  --       },
  --       {
  --         ft = 'help',
  --         size = {
  --           height = 0.3,
  --         },
  --         -- only show help buffers
  --         filter = function(buf)
  --           return vim.bo[buf].buftype == 'help'
  --         end,
  --       },
  --       {
  --         title = 'Neotest Output',
  --         ft = 'neotest-output-panel',
  --         size = {
  --           height = 0.3,
  --         },
  --       },
  --     },
  --     right = {
  --
  --       {
  --         ft = 'Avante',
  --         size = {
  --           height = 0.7,
  --           width = 0.2,
  --         },
  --       },
  --       {
  --         ft = 'AvanteInput',
  --         size = {
  --           height = 0.3,
  --           width = 0.2,
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    -- For some more potential config options:
    -- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/ui.lua#L98
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sections = {
        -- Available components: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#available-components
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', 'searchcount' },
        lualine_x = { 'copilot', 'diagnostics' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim', -- UI component library
      'rcarriga/nvim-notify', -- optional, but we use it for notifications!
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  {
    'echasnovski/mini.animate',
    opts = {
      scroll = {
        enable = false,
      },
      open = {
        -- Whether to enable this animation
        enable = false,
      },
      resize = {
        -- Whether to enable this animation
        enable = false,
      },
      close = {
        -- Whether to enable this animation
        enable = false,
      },
    },
  },
}
