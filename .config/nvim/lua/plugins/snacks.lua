return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
                                            
                                            
        GGGGGGGGGGGGG          GGGGGGGGGGGGG
     GGG::::::::::::G       GGG::::::::::::G
   GG:::::::::::::::G     GG:::::::::::::::G
  G:::::GGGGGGGG::::G    G:::::GGGGGGGG::::G
 G:::::G       GGGGGG   G:::::G       GGGGGG
G:::::G                G:::::G              
G:::::G                G:::::G              
G:::::G    GGGGGGGGGG  G:::::G    GGGGGGGGGG
G:::::G    G::::::::G  G:::::G    G::::::::G
G:::::G    GGGGG::::G  G:::::G    GGGGG::::G
G:::::G        G::::G  G:::::G        G::::G
 G:::::G       G::::G   G:::::G       G::::G
  G:::::GGGGGGGG::::G    G:::::GGGGGGGG::::G
   GG:::::::::::::::G     GG:::::::::::::::G
     GGG::::::GGG:::G       GGG::::::GGG:::G
        GGGGGG   GGGG          GGGGGG   GGGG
                                            
                                            
                                            
                                            
                                            
                                            
                                            ]],
          keys = {
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'o', desc = 'Old (Recent) Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'r', desc = 'Restore Session', action = ':SessionRestore' },
            { icon = ' ', key = 's', desc = 'Session Search', action = ':SessionSearch' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
      },
      quickfile = { enabled = true },
      indent = { enabled = true },
      terminal = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      explorer = {
        enabled = true,
      },
      picker = {
        sources = {
          explorer = {
            ignored = true,
            hidden = true,
            exclude = { 'node_modules', '.git', '.cache' },
            win = {
              list = {
                keys = {
                  ['<BS>'] = 'explorer_up',
                  ['l'] = 'confirm',
                  ['h'] = 'explorer_close', -- close directory
                  ['a'] = 'explorer_add',
                  ['d'] = 'explorer_del',
                  ['r'] = 'explorer_rename',
                  ['c'] = 'explorer_copy',
                  ['m'] = 'explorer_move',
                  ['o'] = 'explorer_open', -- open with system application
                  ['P'] = 'toggle_preview',
                  ['y'] = { 'explorer_yank', mode = { 'n', 'x' } },
                  ['p'] = 'explorer_paste',
                  ['u'] = 'explorer_update',
                  ['<c-c>'] = 'tcd',
                  ['<leader>s'] = 'picker_grep',
                  ['<c-t>'] = 'terminal',
                  ['.'] = 'explorer_focus',
                  ['I'] = 'toggle_ignored',
                  ['H'] = 'toggle_hidden',
                  ['Z'] = 'explorer_close_all',
                  [']g'] = 'explorer_git_next',
                  ['[g'] = 'explorer_git_prev',
                  [']d'] = 'explorer_diagnostic_next',
                  ['[d'] = 'explorer_diagnostic_prev',
                  [']w'] = 'explorer_warn_next',
                  ['[w'] = 'explorer_warn_prev',
                  [']e'] = 'explorer_error_next',
                  ['[e'] = 'explorer_error_prev',
                },
              },
            },
          },
        },
      },

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
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 5, total = 50 },
          easing = 'linear',
        },
      },
      -- words = { enabled = true },
      -- styles = {
      --   notification = {
      --     -- wo = { wrap = true } -- Wrap notifications
      --   },
      -- },
    },
    keys = {
      -- Pickers
      {
        '<leader><space>',
        function()
          Snacks.picker.smart()
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
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
      {
        '<leader>E',
        function()
          Snacks.explorer.open()
        end,
      },
    },
  },
}
