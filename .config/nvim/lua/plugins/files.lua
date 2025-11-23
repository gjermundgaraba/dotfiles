-- local search = require "functionality.search"

return {
  { -- File explorer
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      -- "ibhagwan/fzf-lua", -- used in custom keymaps
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
    lazy = false,
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
            local search = require "functionality.search"
            local node = state.tree:get_node()

            if node.type == "directory" then
              search.live_grep_in_directory(node.path)
            else
              search.live_grep_in_directory(node:get_parent_id())
            end
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
