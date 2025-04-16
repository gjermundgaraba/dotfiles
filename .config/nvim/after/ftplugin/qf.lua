vim.keymap.set("n", "<leader>r", function()
  require("quicker").refresh()
end, { buffer = 0, desc = "Refresh quickfix list" })
