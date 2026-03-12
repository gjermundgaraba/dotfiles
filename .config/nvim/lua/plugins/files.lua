return {
  { -- File explorer that lets you edit filesystem like a buffer
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function(_, opts)
      local oil = require "oil"
      oil.setup(opts)

      local map = require "utils.keymapper"
      map.nmap("<leader>e", oil.open_float, { desc = "Open Oil (float)" })
      map.nmap("<leader>-", oil.open_float, { desc = "Open parent directory" })
    end,
  },

  { -- File explorer
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
        version = "2.*",
        config = function()
          require("window-picker").setup {
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          }
        end,
      },
    },
    cmd = "Neotree",
    init = function()
      -- Register keymap before plugin loads (init runs at startup)
      local map = require "utils.keymapper"
      map.nmap("<leader>E", "<cmd>Neotree toggle<CR>", { desc = "Open File Explorer" })
    end,
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
            ".idea",
          },
          never_show = {},
        },
      },
      window = {
        width = 35,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<D-S-f>"] = function(state)
            local fzf = require "fzf-lua"
            local node = state.tree:get_node()
            local dir = node.type == "directory" and node.path or node:get_parent_id()
            fzf.live_grep { search_paths = { dir } }
          end,
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
  },
}
