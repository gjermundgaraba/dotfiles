return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "*" },
      "mrcjkb/rustaceanvim",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-golang" {
            testify_enabled = true,
          },
          require "rustaceanvim.neotest",
        },
      }
    end,
  },
}
