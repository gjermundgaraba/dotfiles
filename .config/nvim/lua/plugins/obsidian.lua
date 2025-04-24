return {
  "obsidian-nvim/obsidian.nvim",
  dev = true,
  -- version = "*", -- currently using latest to test new features
  lazy = false, -- load on startup, so we can use Obsidian Client commands like search and quick switch
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "saghen/blink.cmp",
    "folke/snacks.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "ggbrain",
        path = "/Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain",
      },
    },
    templates = {
      folder = "Templates",
      date_format = "%d-%m-%Y",
      time_format = "%H:%M",
    },
    completion = {
      nvim_cmp = false,
      blink = true,
      -- min_chars = 2,
    },
    wiki_link_func = "use_alias_only",
    ui = {
      enable = false,
    },
    picker = {
      name = "snacks.pick",
    },
    note_id_func = function(title)
      return title
    end,
  },
}
