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
      --       scroll = {
      --         enabled = true,
      --         animate = {
      --           duration = { step = 5, total = 50 },
      --           easing = "linear",
      --         },
      --       },
      --       zen = { enabled = true },
      --       -- toggle = { enabled = true },
      --       -- words = { enabled = true },
      --     },
    },
  },
}
