local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local default_terminal = Terminal:new {
  direction = "float",
  hidden = true,
}
local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  hidden = true,
}

function M.toggle_default_terminal()
  default_terminal:toggle()
end

function M.toggle_git_terminal()
  lazygit:toggle()
end

return M
