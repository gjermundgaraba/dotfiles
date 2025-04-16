return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-macchiato"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
      },
    },
  },
  { -- scrollbar with "minimap"
    "lewis6991/satellite.nvim",
  },
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = true,
      },
      -- Document existing key chains
      spec = {
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>g", group = "[G]it" },
        { "<leader>l", group = "[L]SP" },
        { "<leader>s", group = "[F]ind" },
        { "<leader>t", group = "[T]ests" },
      },
    },
  },
}
