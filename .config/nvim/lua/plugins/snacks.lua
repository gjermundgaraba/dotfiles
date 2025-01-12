return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
      terminal = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      styles = {
        terminal = {
          keys = {
            term_normal = {
              '<esc>',
              function(self)
                self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                if self.esc_timer:is_active() then
                  self.esc_timer:stop()
                  vim.cmd 'stopinsert'
                else
                  self.esc_timer:start(200, 0, function() end)
                  return '<esc>'
                end
              end,
              mode = 't',
              expr = true,
              desc = 'Double escape to normal mode',
            },
            toggle = {
              '<D-T>',
              function()
                Snacks.terminal()
              end,
              mode = 't',
              expr = true,
            },
          },
        },
      },
      --input = { enabled = true },
      -- notifier = {
      --   enabled = true,
      --   timeout = 3000,
      -- },
      --scroll = { enabled = true },
      --statuscolumn = { enabled = true },
      --words = { enabled = true },
      -- styles = {
      --   notification = {
      --     -- wo = { wrap = true } -- Wrap notifications
      --   },
      -- },
    },
    keys = {
      {
        '<D-T>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
      },
      {
        '<leader>nh',
        function()
          Snacks.notifier.show_history()
        end,
      },
      {
        '<leader>nc',
        function()
          Snacks.notifier.hide()
        end,
      },
    },
  },
}
