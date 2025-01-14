return {
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
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end
      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = 'Add file to harpoon' })
      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
      end, { desc = 'Clear harpoon' })
      vim.keymap.set('n', '<leader>hh', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<C-S-1>', function()
        harpoon:list():replace_at(1)
      end, { desc = 'Replace file in harpoon 1' })
      vim.keymap.set('n', '<C-S-2>', function()
        harpoon:list():replace_at(2)
      end, { desc = 'Replace file in harpoon 2' })
      vim.keymap.set('n', '<C-S-3>', function()
        harpoon:list():replace_at(3)
      end, { desc = 'Replace file in harpoon 3' })
      vim.keymap.set('n', '<C-S-4>', function()
        harpoon:list():replace_at(4)
      end, { desc = 'Replace file in harpoon 4' })
      vim.keymap.set('n', '<C-S-5>', function()
        harpoon:list():replace_at(5)
      end, { desc = 'Replace file in harpoon 5' })
      vim.keymap.set('n', '<C-1>', function()
        harpoon:list():select(1)
      end, { desc = 'Select file in harpoon 1' })
      vim.keymap.set('n', '<C-2>', function()
        harpoon:list():select(2)
      end, { desc = 'Select file in harpoon 2' })
      vim.keymap.set('n', '<C-3>', function()
        harpoon:list():select(3)
      end, { desc = 'Select file in harpoon 3' })
      vim.keymap.set('n', '<C-4>', function()
        harpoon:list():select(4)
      end, { desc = 'Select file in harpoon 4' })
      vim.keymap.set('n', '<C-5>', function()
        harpoon:list():select(5)
      end, { desc = 'Select file in harpoon 5' })

      -- Toggle previous & next buffers stored within Harpoon list
      -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
      -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
    end,
  },
}
