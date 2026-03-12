-- Core keymap functions
local M = {}

local registry = require "utils.keymapper.registry"

---@class MapOpts
---@field desc string Required description
---@field override? boolean Allow overriding existing keymap
---@field buffer? number Buffer-local keymap
---@field expr? boolean Expression mapping
---@field silent? boolean Silent mapping (default: true)
---@field nowait? boolean No wait for additional keys

---Create a keymap with duplicate detection
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? MapOpts
---@param _depth_offset? number Internal: stack depth offset
function M.map(mode, lhs, rhs, opts, _depth_offset)
  opts = opts or {}
  _depth_offset = _depth_offset or 0

  local caller = registry.get_caller_info(_depth_offset)

  -- Require description
  if not opts.desc then
    vim.notify(string.format("[keymapper] Missing desc: %s (%s)", lhs, caller), vim.log.levels.WARN)
  end

  -- Normalize mode to table
  local modes = type(mode) == "table" and mode or { mode }

  -- Check for duplicates (throws on conflict)
  registry.check_and_register(modes, lhs, opts, caller)

  -- Set defaults and clean custom options
  local vim_opts = vim.tbl_extend("force", {}, opts)
  vim_opts.silent = opts.silent ~= false -- default true
  vim_opts.override = nil -- don't pass to vim.keymap.set

  vim.keymap.set(mode, lhs, rhs, vim_opts)
end

-- Mode-specific wrappers (pass depth_offset=1 to account for wrapper stack frame)
function M.nmap(lhs, rhs, opts)
  M.map("n", lhs, rhs, opts, 1)
end
function M.imap(lhs, rhs, opts)
  M.map("i", lhs, rhs, opts, 1)
end
function M.vmap(lhs, rhs, opts)
  M.map("v", lhs, rhs, opts, 1)
end
function M.xmap(lhs, rhs, opts)
  M.map("x", lhs, rhs, opts, 1)
end
function M.tmap(lhs, rhs, opts)
  M.map("t", lhs, rhs, opts, 1)
end
function M.omap(lhs, rhs, opts)
  M.map("o", lhs, rhs, opts, 1)
end

---Leader keymap shorthand
---@param lhs string Key without <leader> prefix
---@param rhs string|function
---@param opts? MapOpts
function M.leader(lhs, rhs, opts)
  M.map("n", "<leader>" .. lhs, rhs, opts, 1)
end

---Create a lazy-require function wrapper
---Module is only loaded when the keymap is triggered
---@param module string Module path
---@param fn_name string Function name to call
---@return function
function M.lazy(module, fn_name)
  return function(...)
    return require(module)[fn_name](...)
  end
end

---Create a lazy-require for nested module path
---e.g., M.lazy_nested("module", "sub", "fn")
---@param module string Module path
---@param ... string Nested keys to traverse
---@return function
function M.lazy_nested(module, ...)
  local keys = { ... }
  return function(...)
    local mod = require(module)
    for _, key in ipairs(keys) do
      mod = mod[key]
    end
    return mod(...)
  end
end

return M
