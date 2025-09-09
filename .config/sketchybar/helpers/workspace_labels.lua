local M = {}

-- Public event name used to notify SketchyBar items to refresh labels
M.event = "workspace_labels_changed"

-- Resolve config directory and labels file path
local function config_dir()
  local xdg = os.getenv("XDG_CONFIG_HOME")
  local home = os.getenv("HOME")
  if xdg and #xdg > 0 then
    return xdg .. "/sketchybar"
  else
    return home .. "/.config/sketchybar"
  end
end

local LABELS_FILE = config_dir() .. "/workspace_labels.toml"

-- Simple helpers
local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function escape_str(s)
  -- Minimal TOML string escape: backslash and quote
  s = s:gsub("\\", "\\\\")
  s = s:gsub("\"", "\\\"")
  return s
end

local function unescape_str(s)
  -- Reverse of escape_str
  local out = {}
  local i = 1
  while i <= #s do
    local c = s:sub(i, i)
    if c == "\\" then
      local n = s:sub(i + 1, i + 1)
      if n == "\\" or n == '"' then
        table.insert(out, n)
        i = i + 2
      elseif n == "n" then
        table.insert(out, "\n")
        i = i + 2
      elseif n == "t" then
        table.insert(out, "\t")
        i = i + 2
      else
        -- Unknown escape, keep literal following char
        table.insert(out, n)
        i = i + 2
      end
    else
      table.insert(out, c)
      i = i + 1
    end
  end
  return table.concat(out)
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local data = f:read("*a")
  f:close()
  return data
end

local function write_file_atomic(path, content)
  local tmp = path .. ".tmp"
  local f, err = io.open(tmp, "w")
  if not f then
    return nil, err or "failed to open temp file"
  end
  f:write(content)
  f:flush()
  f:close()
  os.remove(path) -- ignore error
  local ok, rerr = os.rename(tmp, path)
  if not ok then
    return nil, rerr or "failed to rename temp file"
  end
  return true
end

-- Parse a very small TOML subset:
--  - Accept comments starting with '#'
--  - Expect a section [labels]
--  - Within that section: keys and values are strings (keys may be quoted or bare)
--  - Values must be quoted strings; we'll unescape minimal escapes
local function parse_labels_toml(str)
  local labels = {}
  if not str or #str == 0 then return labels end
  local in_section = false
  for line in (str .. "\n"):gmatch("(.-)\n") do
    local l = trim(line)
    if l == "" or l:match("^#") then goto continue end
    if l:match("^%[labels%]%s*$") then
      in_section = true
      goto continue
    end
    if l:match("^%[.+%]%s*$") then
      in_section = false
      goto continue
    end
    if in_section then
      -- Remove inline comments if present (only when preceded by space)
      l = l:gsub("%s+#.*$", "")
      local keypart, valpart = l:match("^(.-)%s*=%s*(.-)%s*$")
      if keypart and valpart then
        keypart = trim(keypart)
        valpart = trim(valpart)
        -- Key: quoted or bare
        local key
        if keypart:match('^".*"$') then
          key = keypart:sub(2, -2)
          key = unescape_str(key)
        else
          key = keypart
        end
        -- Value: must be quoted
        if valpart:match('^".*"$') then
          local v = valpart:sub(2, -2)
          v = unescape_str(v)
          labels[key] = v
        end
      end
    end
    ::continue::
  end
  return labels
end

local function serialize_labels_toml(labels)
  local keys = {}
  for k, _ in pairs(labels) do table.insert(keys, k) end
  table.sort(keys, function(a, b)
    -- numeric IDs first by numeric order, then lexicographic
    local na, nb = tonumber(a), tonumber(b)
    if na and nb then return na < nb end
    if na and not nb then return true end
    if nb and not na then return false end
    return a < b
  end)

  local out = {}
  table.insert(out, "# Workspace labels for SketchyBar Aerospace spaces\n")
  table.insert(out, "[labels]\n")
  for _, k in ipairs(keys) do
    local v = labels[k]
    local line = ("\"%s\" = \"%s\"\n"):format(escape_str(k), escape_str(v))
    table.insert(out, line)
  end
  return table.concat(out)
end

-- Cache and API
local cache = nil

function M.path()
  return LABELS_FILE
end

function M.reload()
  local content = read_file(LABELS_FILE)
  cache = parse_labels_toml(content)
  return cache
end

local function ensure_loaded()
  if cache == nil then M.reload() end
end

function M.labels()
  ensure_loaded()
  local copy = {}
  for k, v in pairs(cache) do copy[k] = v end
  return copy
end

function M.get_label(id)
  ensure_loaded()
  return cache[id]
end

function M.set_label(id, label)
  assert(type(id) == "string" and #id > 0, "id must be non-empty string")
  assert(type(label) == "string" and #label > 0, "label must be non-empty string")
  ensure_loaded()
  cache[id] = label
  local content = serialize_labels_toml(cache)
  local ok, err = write_file_atomic(LABELS_FILE, content)
  if not ok then error(err) end
  return true
end

function M.clear_label(id)
  assert(type(id) == "string" and #id > 0, "id must be non-empty string")
  ensure_loaded()
  cache[id] = nil
  local content = serialize_labels_toml(cache)
  local ok, err = write_file_atomic(LABELS_FILE, content)
  if not ok then error(err) end
  return true
end

function M.clear_all()
  cache = {}
  local content = serialize_labels_toml(cache)
  local ok, err = write_file_atomic(LABELS_FILE, content)
  if not ok then error(err) end
  return true
end

function M.format_display(id)
  ensure_loaded()
  local lbl = cache[id]
  if lbl and #lbl > 0 then
    return string.format("%s: %s", id, lbl)
  else
    return id
  end
end

return M
