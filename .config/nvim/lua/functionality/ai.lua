local M = {}

local copilot = require "copilot.suggestion"

function M.accept()
  copilot.accept()
end

function M.accept_word()
  copilot.accept_word()
end

return M
