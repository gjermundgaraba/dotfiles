return {
  { -- theme manager (themes are also installed here as dependencies)
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = {
      'folke/tokyonight.nvim',
      'rmehri01/onenord.nvim',
      'AlexvZyl/nordic.nvim',
      'EdenEast/nightfox.nvim',
      { 'catppuccin/nvim', name = 'catppuccin' },
      'shaunsingh/moonlight.nvim',
      'dgox16/oldworld.nvim',
    },
    config = function()
      require('themery').setup {
        themes = {
          'tokyonight',
          'onenord',
          'nordic',
          'nightfox',
          'catppuccin',
          'catppuccin-macchiato',
          'moonlight',
          'oldworld',
        },
        livePreview = true,
      }
    end,
  },
  { -- scrollbar with "minimap"
    -- potential alternative: "dstein64/nvim-scrollview"
    'lewis6991/satellite.nvim',
  },
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
  { -- notifications and popups and shit
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
    'sphamba/smear-cursor.nvim',
    opts = {},
  },
}
