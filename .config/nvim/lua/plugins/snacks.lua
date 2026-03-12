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
      bufdelete = { enabled = false },
      notifier = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true,             -- show open fold icons
          git_hl = false,          -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms

      },
    },
    config = function(_, opts)
      local Snacks = require "snacks"
      Snacks.setup(opts)

      local map = require "utils.keymapper"
      map.nmap("<D-w>", Snacks.bufdelete.delete, { desc = "Close buffer" })
      map.nmap("<D-S-w>", Snacks.bufdelete.other, { desc = "Close other buffers" })
      -- Warp/Karabiner F-key aliases
      map.nmap("<F14>", Snacks.bufdelete.delete, { desc = "Close buffer" })
      map.nmap("<F16>", Snacks.bufdelete.other, { desc = "Close other buffers" })
    end,
  },
}
