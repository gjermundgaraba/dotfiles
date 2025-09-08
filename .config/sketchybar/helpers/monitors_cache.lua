-- Simple module to share dynamically-resolved monitor mapping across requires
-- init.lua populates M.map before requiring modules that depend on settings.lua
local M = {
  map = nil,
}

return M

