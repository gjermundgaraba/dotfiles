-- Main API - re-exports all submodules
local map = require "utils.keymapper.map"
local groups = require "utils.keymapper.groups"
local registry = require "utils.keymapper.registry"

local M = {}

-- Core mapping functions
M.map = map.map
M.nmap = map.nmap
M.imap = map.imap
M.vmap = map.vmap
M.xmap = map.xmap
M.tmap = map.tmap
M.omap = map.omap
M.leader = map.leader

-- Lazy helpers
M.lazy = map.lazy
M.lazy_nested = map.lazy_nested

-- Which-key groups
M.group = groups.add
M.register_groups = groups.register_all

-- Debug/testing
M.reset_registry = registry.reset
M.get_registry = registry.get_all

return M
