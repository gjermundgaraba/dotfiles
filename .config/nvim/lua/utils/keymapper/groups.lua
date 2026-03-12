-- Which-key group registration
local M = {}

local pending_groups = {}
local groups_registered = false

---Register a which-key group
---@param prefix string Key prefix (e.g., "<leader>s")
---@param name string Display name (e.g., "[S]earch")
---@param opts? { icon?: string, mode?: string|string[] }
function M.add(prefix, name, opts)
  opts = opts or {}
  local group_spec = {
    prefix,
    group = name,
    icon = opts.icon,
    mode = opts.mode,
  }

  if groups_registered then
    require("which-key").add(group_spec)
  else
    table.insert(pending_groups, group_spec)
  end
end

---Flush pending groups to which-key (call after which-key loads)
function M.register_all()
  if groups_registered then
    return
  end
  groups_registered = true

  if #pending_groups > 0 then
    local wk = require "which-key"
    for _, spec in ipairs(pending_groups) do
      wk.add(spec)
    end
  end
end

--- Reset state (for testing)
function M.reset()
  pending_groups = {}
  groups_registered = false
end

return M
