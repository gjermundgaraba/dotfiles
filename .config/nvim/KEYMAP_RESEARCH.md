# Best Practices for Neovim Keymap Configuration

**Confidence:** High — Based on current community consensus, LazyVim patterns, and nvim-best-practices guidelines.

**Research Date:** January 2026

---

## Executive Summary

Your current setup is already **well-architected**. The main opportunities for improvement are:

1. **Consider replacing which-key with mini.clue** (lighter, more focused)
2. **Use lazy.nvim's `keys` spec for plugin keymaps** (better co-location and lazy loading)
3. **Leverage snacks.nvim** (you have it installed but not using its keymap features)
4. **Add a keymap utility wrapper** for consistency and maintainability

---

## 1. Organization Pattern: Hybrid Approach (Recommended)

The **most maintainable pattern** for advanced users is a **hybrid approach**:

| Location | What Goes There |
|----------|-----------------|
| `lua/config/keymaps.lua` | Core editor keymaps (navigation, windows, buffers, escape, etc.) |
| Plugin spec `keys = {}` | Plugin-specific keymaps (lazy-loaded automatically) |
| `ftplugin/{filetype}.lua` | Filetype-specific keymaps |
| `after/plugin/` or autocmds | LSP/buffer-attached keymaps |

### Why Hybrid?

```lua
-- GOOD: Plugin keymaps co-located with plugin config
-- lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  },
  -- Keymaps auto lazy-load the plugin when pressed!
}

-- GOOD: Core keymaps centralized
-- lua/config/keymaps.lua
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
```

This gives you:
- **Discoverability**: Core keymaps in one place
- **Maintainability**: Plugin keymaps stay with their config
- **Performance**: Automatic lazy-loading via `keys` spec

---

## 2. Which-Key Alternatives: Consider mini.clue

| Feature | which-key.nvim | mini.clue | snacks.nvim |
|---------|---------------|-----------|-------------|
| Popup hints | Yes | Yes | No (picker only) |
| Active maintenance | Yes | Yes | Yes |
| Dependencies | 0 | 0 | 0 |
| Size/complexity | Medium | Minimal | Large (many features) |
| Auto-triggers | Yes | Yes | N/A |
| Hydra mode | Yes | Yes | No |
| Custom clues | Limited | Excellent | N/A |

### Recommendation: mini.clue or keep which-key

**mini.clue** advantages:
- Simpler, more focused (does one thing well)
- Part of the excellent mini.nvim ecosystem
- Better support for custom "clues" (helpful hints that aren't keymaps)
- Lighter weight

```lua
-- mini.clue example
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '"' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    -- Custom group clues
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  },
})
```

**However**, which-key.nvim is:
- More popular (better community support)
- More feature-rich
- What you already know

**Verdict**: If which-key is working for you, keep it. Switch to mini.clue if you want something simpler.

---

## 3. Keymap Utility Pattern (Recommended Addition)

Create a small utility for consistent keymap creation:

```lua
-- lua/config/keymap-utils.lua
local M = {}

---@class KeymapOpts
---@field desc string
---@field buffer? number
---@field expr? boolean
---@field silent? boolean
---@field nowait? boolean

---Create a keymap with sensible defaults
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts KeymapOpts
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false -- default true
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Convenience wrappers
function M.nmap(lhs, rhs, opts) M.map('n', lhs, rhs, opts) end
function M.imap(lhs, rhs, opts) M.map('i', lhs, rhs, opts) end
function M.vmap(lhs, rhs, opts) M.map('v', lhs, rhs, opts) end
function M.xmap(lhs, rhs, opts) M.map('x', lhs, rhs, opts) end
function M.tmap(lhs, rhs, opts) M.map('t', lhs, rhs, opts) end

---Create a leader keymap
---@param lhs string (without <leader> prefix)
---@param rhs string|function
---@param opts KeymapOpts
function M.leader(lhs, rhs, opts)
  M.nmap('<leader>' .. lhs, rhs, opts)
end

return M
```

**Usage:**
```lua
local map = require("config.keymap-utils")

map.leader("sf", search.file_picker, { desc = "Search files" })
map.leader("sg", search.live_grep, { desc = "Search with grep" })
map.nmap("gd", lsp.definitions, { desc = "Go to definition" })
```

---

## 4. Lazy.nvim Keys Spec (Use More)

Leverage lazy.nvim's `keys` spec for plugin keymaps:

```lua
-- lua/plugins/oil.lua
return {
  "stevearc/oil.nvim",
  keys = {
    { "-", function() require("oil").open() end, desc = "Open parent directory" },
    { "<leader>e", function() require("oil").open() end, desc = "Open Oil" },
  },
  opts = { ... },
}
```

**Benefits:**
- Plugin only loads when you press the key
- Keymap stays with plugin config
- Easy to see all keymaps for a plugin at a glance
- If plugin is removed, keymap goes with it

---

## 5. Improvements for Current Setup

### Current Issues Identified:

1. **LazyDone autocmd is heavy** — All keymaps load at once after plugins
2. **Duplicate keymap** on line 131-132 (both are `<leader>gsb`)
3. **Missing lazy loading** — Functionality modules are required upfront

### Suggested Improvements:

```lua
-- BEFORE: Loading all modules upfront
local editor = require "functionality.editor"
local search = require "functionality.search"

-- AFTER: Lazy require pattern
vim.keymap.set("n", "<leader>sf", function()
  require("functionality.search").file_picker()
end, { desc = "Search files" })
```

Or create a lazy require utility:
```lua
-- lua/config/keymap-utils.lua (addition)
function M.lazy_require(module, fn_name)
  return function(...)
    return require(module)[fn_name](...)
  end
end

-- Usage:
local lazy = require("config.keymap-utils").lazy_require
vim.keymap.set("n", "<leader>sf", lazy("functionality.search", "file_picker"), { desc = "Search files" })
```

---

## 6. Snacks.nvim Keymap Features

Since you have snacks.nvim, consider using:

```lua
-- Keymap picker (like Telescope keymaps but integrated)
vim.keymap.set("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Search keymaps" })

-- Toggle utilities
Snacks.toggle.option("wrap"):map("<leader>uw")
Snacks.toggle.option("relativenumber"):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
```

---

## 7. Recommended File Structure

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   ├── keymaps.lua        # Core keymaps only
│   │   ├── keymap-utils.lua   # Utility functions
│   │   └── ...
│   ├── plugins/
│   │   ├── telescope.lua      # Plugin keymaps via `keys = {}`
│   │   ├── oil.lua
│   │   └── ...
│   └── functionality/         # Keep as-is, great pattern!
│       ├── code.lua
│       ├── search.lua
│       └── ...
└── after/
    └── ftplugin/
        └── rust.lua           # Filetype-specific keymaps
```

---

## 8. Best Practices Summary

| Practice | Rationale |
|----------|-----------|
| **Always use `desc`** | Essential for which-key/mini.clue and discoverability |
| **Prefer functions over strings** | `function() ... end` over `":cmd<CR>"` for flexibility |
| **Use `<Plug>` for exposing actions** | If you write plugins or share config |
| **Group related keymaps** | Use which-key groups or mini.clue clues |
| **Lazy require modules** | Better startup time |
| **Co-locate plugin keymaps** | Easier maintenance |
| **Use `buffer` option for buffer-local maps** | LSP, filetype-specific |
| **Delete conflicting default maps** | You're already doing this well! |

---

## Sources Consulted

- [LazyVim Keymap Configuration](https://lazyvim.github.io/configuration/keymaps)
- [nvim-best-practices (lumen-oss)](https://github.com/lumen-oss/nvim-best-practices)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [echasnovski/mini.clue](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- Various community configs and discussions

---

## Limitations

- Mini.clue is less popular, so fewer community examples
- snacks.nvim doesn't have a which-key-style popup (only picker)
- The "best" pattern is subjective and depends on personal workflow

---

## Next Steps

1. **Draft a refactored version** of keymaps.lua using these patterns
2. **Show a complete mini.clue migration** from which-key setup
3. **Create the keymap utility module** for the config
