return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@type render.md.UserConfig
    opts = {
      heading = {
        width = "block",
        min_width = 50,
        backgrounds = {},
      },
    },
  },
}
