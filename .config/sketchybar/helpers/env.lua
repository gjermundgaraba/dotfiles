local settings = require("settings")
local monitors = require("helpers.monitors")

local M = { ctx = nil }

local function call_display_info()
  local bin = os.getenv("HOME") .. "/.config/sketchybar/helpers/event_providers/display_info/bin/display_info"
  local f = io.popen(bin)
  if not f then return { builtin_main = false, display_count = 1 } end
  local builtin, count = false, 1
  for line in f:lines() do
    local k, v = line:match("([^=]+)=(%d+)")
    if k == "builtin_main" then builtin = (v == "1") end
    if k == "display_count" then count = tonumber(v) or 1 end
  end
  f:close()
  return { builtin_main = builtin, display_count = count }
end

local function compute_ctx()
  local info = call_display_info()
  local main_id = monitors.get_main_display_id(settings.monitors.main_uuid)
  local builtin_id = settings.monitors.builtin_uuid and monitors.get_display_id_by_uuid(settings.monitors.builtin_uuid) or nil
  return {
    builtin_is_main = info.builtin_main,
    display_count = info.display_count,
    laptop_only = info.builtin_main and info.display_count == 1,
    main_display_id = main_id or monitors.get_default_display_id(),
    builtin_display_id = builtin_id or monitors.get_default_display_id(),
  }
end

function M.reload()
  M.ctx = compute_ctx()
  return M.ctx
end

local function ctx()
  return M.ctx or M.reload()
end

function M.laptop_only()
  return ctx().laptop_only
end

function M.main_display_id()
  return ctx().main_display_id
end

function M.builtin_display_id()
  return ctx().builtin_display_id
end

function M.pick(laptop_val, other_val)
  return M.laptop_only() and laptop_val or other_val
end

return M
