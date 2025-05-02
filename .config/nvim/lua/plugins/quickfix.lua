return {
  {
    "stevearc/quicker.nvim",
    dev = true,
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      follow = {
        enabled = true,
      },
    },
  },
}
