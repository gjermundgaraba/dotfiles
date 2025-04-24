return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      -- require("catppuccin").setup {
      --   color_overrides = {
      --     macchiato = {
      --       mauve = "#ec91d7",
      --       base = "#262b36",
      --       surface0 = "#373f4d",
      --       crust = "#15181e",
      --       mantle = "#1e222a",
      --     },
      --     mocha = {
      --       base = "#262b36",
      --       surface0 = "#373f4d",
      --       crust = "#15181e",
      --       mantle = "#1e222a",
      --     },
      --   },
      -- }
      vim.cmd.colorscheme "catppuccin-macchiato"
    end,
  },
  { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      keywords = {
        H1 = { icon = "󰉫", color = "hint" },
        H2 = { icon = "󰉬", color = "hint" },
        H3 = { icon = "󰉭", color = "hint" },
        TODO = { color = "default" },
      },
    },
  },
  { -- Buffers as "tabs"
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diagnostics_dict, _)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or " ")
            s = s .. n .. sym
          end
          return s
        end,
      },
    },
  },
  { -- scrollbar with "minimap"
    "lewis6991/satellite.nvim",
    opts = {
      handlers = {
        gitsigns = {
          enable = false, -- Something buggy with this, doesn't work correctly
        },
      },
    },
  },
  { -- Show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = true, -- for Nerd Fonts
      },
    },
  },
}
