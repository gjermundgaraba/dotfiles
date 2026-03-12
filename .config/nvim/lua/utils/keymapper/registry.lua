-- Keymap registry for duplicate detection
local M = {}

local registry = {}

--- Normalize key for comparison
--- Only lowercases special key notation (<Leader>, <C-x>, etc.), not bare characters
--- This ensures <leader>E and <leader>e are treated as different keys
---@param key string
---@return string
function M.normalize_key(key)
  -- Expand <leader> to actual leader key
  local result = key:gsub("<[Ll][Ee][Aa][Dd][Ee][Rr]>", vim.g.mapleader or "\\")

  -- Normalize angle-bracket notation to lowercase (e.g., <C-X> -> <c-x>, <S-Tab> -> <s-tab>)
  -- But preserve the case of characters outside angle brackets
  result = result:gsub("<([^>]+)>", function(inner)
    return "<" .. inner:lower() .. ">"
  end)

  return result
end

--- Get calling location for error messages
---@param depth_offset? number Additional stack frames to skip
---@return string
function M.get_caller_info(depth_offset)
  local depth = 4 + (depth_offset or 0) -- account for module layers
  local info = debug.getinfo(depth, "Sl")
  if info then
    return string.format("%s:%d", info.short_src, info.currentline)
  end
  return "unknown"
end

--- Check for duplicate and register keymap
--- Throws error if duplicate found (unless override=true or buffer-local)
---@param modes string[]
---@param lhs string
---@param opts table
---@param caller string
function M.check_and_register(modes, lhs, opts, caller)
  if opts.buffer then
    return
  end -- buffer-local keymaps can shadow

  local normalized_lhs = M.normalize_key(lhs)

  for _, m in ipairs(modes) do
    local key = m .. ":" .. normalized_lhs
    if registry[key] and not opts.override then
      error(
        string.format(
          "[keymapper] Duplicate keymap: '%s' (mode: %s)\n"
            .. "  Registered at: %s\n"
            .. "  Conflict at:   %s\n"
            .. "Use { override = true } to intentionally replace.",
          lhs,
          m,
          registry[key],
          caller
        )
      )
    end
    -- Only register first occurrence to preserve original source location
    if not registry[key] then
      registry[key] = caller
    end
  end
end

--- Clear registry (for testing or reloading)
function M.reset()
  registry = {}
end

--- Get current registry (for debugging)
---@return table
function M.get_all()
  return vim.deepcopy(registry)
end

return M
