return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            function()
              local reg = vim.fn.reg_recording()
              -- If a macro is being recorded, show "Recording @<register>"
              if reg ~= '' then
                return '🔴 => @' .. reg
              else
                -- Get the full mode name using nvim_get_mode()
                local mode = vim.api.nvim_get_mode().mode
                local mode_map = {
                  n = 'NORMAL',
                  i = 'INSERT',
                  v = 'VISUAL',
                  V = 'V-LINE',
                  ['^V'] = 'V-BLOCK',
                  c = 'COMMAND',
                  R = 'REPLACE',
                  s = 'SELECT',
                  S = 'S-LINE',
                  ['^S'] = 'S-BLOCK',
                  t = 'TERMINAL',
                }

                -- Return the full mode name
                return mode_map[mode] or mode:upper()
              end
            end,
          },
          'branch',
          'diff',
        },
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
}
