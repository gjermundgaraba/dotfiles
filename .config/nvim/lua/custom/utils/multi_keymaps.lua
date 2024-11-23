--- @class MultiKeymap
local M = {}

-- Structure: keymap[key][mode] = table[]
M.keymap = {}

-- Internal helper function to set a callback fr a single mode and key into our internal keymap structure
--- @param mode string
--- @param key string
--- @param cb function
local function setCallback(mode, key, cb)
  if type(mode) ~= 'string' then
    error 'Each mode must be a string'
  end

  if not M.keymap[key][mode] then
    M.keymap[key][mode] = {}
  end

  table.insert(M.keymap[key][mode], cb)
end

-- Callback function for the actual vim.keymap.set
--- @param key string
local function executeKeymap(key)
  local key_entry = M.keymap[key]
  if key_entry then
    local modeResp = vim.api.nvim_get_mode()
    local cbs = key_entry[modeResp.mode]
    if cbs then
      for _, cb in pairs(cbs) do
        cb()
      end
    else
      error("No callback found for key: '" .. tostring(key) .. "' in mode: '" .. tostring(modeResp) .. "'")
    end
  else
    error('No callbacks registered for key: ' .. tostring(key))
  end
end

-- Create a new keymap with all modes we currently have
local function createKeymap(key)
  local modes = {}
  for m, _ in pairs(M.keymap[key]) do
    table.insert(modes, m)
  end

  vim.keymap.set(modes, key, function()
    executeKeymap(key)
  end)
end

-- Function to add a new callback to a keymap
-- If the keymap doesn't exist, it will be created
--- @param mode string|string[]: An array of strings representing the modes
--- @param key string: The key for the keymap
--- @param cb function: The callback function associated with the key and modes
function M.add(mode, key, cb)
  -- Input validation
  if type(key) ~= 'string' then
    error 'Key must be a string or array'
  end
  if type(mode) ~= 'string' and type(mode) ~= 'table' then
    error("Modes must be provided as a table of strings, got: '" .. type(mode) .. "'")
  end
  if type(cb) ~= 'function' then
    error 'Function must be a callable function'
  end

  -- Initialize the sub-table, and keymap for the key if it doesn't exist
  if not M.keymap[key] then
    M.keymap[key] = {}
  end

  -- Iterate over the modes array and assign the function to each mode
  if type(mode) == 'string' then
    setCallback(mode, key, cb)
  else
    for _, m in ipairs(mode) do
      setCallback(m, key, cb)
    end
  end

  -- Set/overwrite keymap
  createKeymap(key)
end

return M
