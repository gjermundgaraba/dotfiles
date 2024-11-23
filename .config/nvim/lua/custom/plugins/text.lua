return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      local multi_keymaps = require 'custom.utils.multi_keymaps'

      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ 'n', 'v' }, '<up>', function()
        mc.lineAddCursor(-1)
      end)
      set({ 'n', 'v' }, '<down>', function()
        mc.lineAddCursor(1)
      end)
      set({ 'n', 'v' }, '<leader><up>', function()
        mc.lineSkipCursor(-1)
      end)
      set({ 'n', 'v' }, '<leader><down>', function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      -- OPT+n = ‘
      set({ 'n', 'v' }, '‘', function()
        mc.matchAddCursor(1)
      end)
      -- OPT+s = ß
      set({ 'n', 'v' }, 'ß', function()
        mc.matchSkipCursor(1)
      end)
      -- OPT+N = “
      set({ 'n', 'v' }, '“', function()
        mc.matchAddCursor(-1)
      end)
      -- OPT+S = ∑
      set({ 'n', 'v' }, '∑', function()
        mc.matchSkipCursor(-1)
      end)

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.
      set({ 'n', 'v' }, '<right>', mc.nextCursor)
      set({ 'n', 'v' }, '<left>', mc.prevCursor)

      -- NOTE: Does the same as skip backwards, no? Commenting out for now
      --
      -- Delete the main cursor.
      -- set({ 'n', 'v' }, '<leader>x', mc.deleteCursor)

      -- Add and remove cursors with mouse
      set('n', '<M-leftmouse>', mc.handleMouse)

      -- OPT+q = •
      set({ 'n', 'v' }, '•', function()
        if mc.cursorsEnabled() then
          -- Stop other cursors from moving.
          -- This allows you to reposition the main cursor.
          mc.disableCursors()
        else
          mc.addCursor()
        end
      end)

      -- NOTE: Not sure what this is good for, so commenting out
      --
      -- clone every cursor and disable the originals
      -- set({ 'n', 'v' }, '<leader><c-q>', mc.duplicateCursors)

      -- Clear cursor
      multi_keymaps.add('n', '<Esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        end
      end)

      -- NOTE: Not sure what I would need this for, so commenting out
      --
      -- Align cursor columns.
      -- set('v', '<leader>a', mc.alignCursors)

      -- NOTE: Not sure what I would need this for, so commenting out
      --
      -- Split visual selections by regex.
      -- set('v', 'S', mc.splitCursors)

      -- Append/insert for each line of visual selections.
      set('v', 'I', mc.insertVisual)
      set('v', 'A', mc.appendVisual)

      -- NOTE: Not sure what I would need this for, so commenting out
      --
      -- match new cursors within visual selections by regex.
      -- set('v', 'M', mc.matchCursors)

      -- NOTE: Not sure what I would need this for, so commenting out
      --
      -- Rotate visual selection contents.
      --set('v', '<leader>‘', function()
      --  mc.transposeCursors(1)
      --end)
      --set('v', '<leader>“', function()
      --  mc.transposeCursors(-1)
      --end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    -- Better Around/Inside textobjects
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    'echasnovski/mini.ai',
    opts = {
      n_lines = 500,
    },
  },
  {
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    'echasnovski/mini.surround',
    opts = {},
  },
  {
    'echasnovski/mini.move',
    opts = {
      mappings = {
        left = '˛',
        right = 'ﬁ',
        down = '√',
        up = 'ª',
        line_left = '˛',
        line_right = 'ﬁ',
        line_down = '√',
        line_up = 'ª',
      },
    },
  },
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
