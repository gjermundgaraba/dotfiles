local M = {}

function M.save()
  vim.cmd "write"
end

function M.open_explorer()
  vim.cmd "Neotree toggle"
end

local oil = require("oil")

function M.open_oil()
  oil.open()
end

function M.open_oil_float()
  oil.open_float()
end

function M.clear()
  M.clear_highlights()
end

function M.clear_highlights()
  vim.cmd "nohlsearch"
end

return M
