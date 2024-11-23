return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = '<S-TAB>',
            next = '<S-Right>',
            prev = '<S-Left>',
          },
        },
      }
    end,
  },
  { 'AndreM222/copilot-lualine' },
}
