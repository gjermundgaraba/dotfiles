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
  -- {
  --   'sphamba/smear-cursor.nvim',
  --   opts = {
  --     smear_between_buffers = false,
  --     stiffness = 0.8, -- 0.6      [0, 1]
  --     trailing_stiffness = 0.5, -- 0.3      [0, 1]
  --     distance_stop_animating = 0.5, -- 0.1      > 0
  --   },
  -- },
}
