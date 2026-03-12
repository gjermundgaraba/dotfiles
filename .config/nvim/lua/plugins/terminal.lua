-- Lazygit terminal instance (created once, reused)
local lazygit_term

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local toggleterm = require "toggleterm"
      toggleterm.setup(opts)

      local map = require "utils.keymapper"

      map.map({ "n", "t" }, "<M-D-t>", function()
        toggleterm.toggle(1, nil, nil, "float")
      end, { desc = "Toggle terminal" })

      map.map({ "n", "i", "t" }, "<F18>", function()
        toggleterm.toggle(1, nil, nil, "float")
      end, { desc = "Toggle terminal" })

      map.nmap("<leader><M-D-t>g", function()
        if not lazygit_term then
          local Terminal = require("toggleterm.terminal").Terminal
          lazygit_term = Terminal:new { cmd = "lazygit", direction = "float", hidden = true }
        end
        lazygit_term:toggle()
      end, { desc = "Toggle lazygit" })
    end,
  },
}
