return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
  { -- scrollbar with "minimap"
    'lewis6991/satellite.nvim', -- potential alternative: "dstein64/nvim-scrollview"
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'branch', 'diff' },
        lualine_b = {},
        lualine_c = {
          {
            'buffers',
            component_separators = { left = ' ' }, -- because of https://github.com/nvim-lualine/lualine.nvim/issues/1322
            icons_enabled = false,
          },
        },
        lualine_x = {},
        lualine_y = { 'diagnostics', 'searchcount' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    },
    extensions = {},
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
