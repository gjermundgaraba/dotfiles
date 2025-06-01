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
      gitbrowse = { enabled = true }, -- TODO: Remove this and make this yourself
    },
  },
}
