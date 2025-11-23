return {
  { -- Library for creating UIs
    "grapp-dev/nui-components.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  { -- Theme
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
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
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
              if reg ~= "" then
                return "🔴 => @" .. reg
              else
                return ""
              end
            end,
          },
          {
            "filename",
            path = 1,
          },
          "diff",
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            function()
              return " "
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
              end
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          }
        },
        lualine_y = { "diagnostics", "searchcount" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
    extensions = {},
  },
  { -- notifications and popups and shit
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim", -- UI component library
      "rcarriga/nvim-notify", -- optional, but we use it for notifications!
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline", -- use the cmdline view for cmdline messages
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
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
  {                     -- Show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = true, -- for Nerd Fonts
      },
    },
  },
}
