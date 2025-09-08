local M = {
  uuid_map = nil,    -- uuid -> arrangement-id (via sketchybar)
  started = false,
}

-- Resolve uuid -> arrangement-id using SketchyBar's displays query
local function resolve_uuid_once()
  local fh = io.popen("sketchybar --query displays")
  if not fh then
    return nil, "io.popen failed"
  end
  local out = fh:read("*a") or ""
  fh:close()
  if out == "" then
    return nil, "no output"
  end

  local map = {}
  for obj in out:gmatch("%b{}") do
    if obj:find('"UUID"') then
      local uuid = obj:match('"UUID"%s*:%s*"([^"]+)"')
      local arr = obj:match('"arrangement%-id"%s*:%s*(%d+)')
      if uuid and arr then
        map[uuid] = tonumber(arr)
      end
    end
  end

  if next(map) == nil then
    return nil, "parsed empty uuid map"
  end
  return map
end

function M.start()
  if M.started then return end
  M.started = true
  local uuid_map, _ = resolve_uuid_once()
  if uuid_map then M.uuid_map = uuid_map end
end

local function ensure_uuid_map()
  if M.uuid_map then return true end
  while true do
    local uuid_map, _ = resolve_uuid_once()
    if uuid_map then
      M.uuid_map = uuid_map
      return true
    end
    os.execute("sleep 0.2")
  end
end

function M.get_display_id_by_uuid(uuid)
  ensure_uuid_map()
  return M.uuid_map and M.uuid_map[uuid]
end

-- Default display: smallest arrangement-id available from SketchyBar
function M.get_default_display_id()
  ensure_uuid_map()
  local min_id
  for _, id in pairs(M.uuid_map or {}) do
    if not min_id or id < min_id then
      min_id = id
    end
  end
  return min_id or 1
end

-- Main display with fallback to default
function M.get_main_display_id(main_uuid)
  return M.get_display_id_by_uuid(main_uuid) or M.get_default_display_id()
end

return M
