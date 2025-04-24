return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = { enabled = true },
      gitbrowse = { enabled = true },
      bigfile = { enabled = true },
      picker = {
        -- sources = {},
        ---@class snacks.picker.layout.Config
        layout = {
          preset = "ivy",
        },
      },
    },
  },
}
