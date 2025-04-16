# gg's neovim

Original starting point: [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

Moved over to dotfiles repo on 23 Nov 2024 from [gjermundgaraba/kickstart.nvim](https://github.com/gjermundgaraba/kickstart.nvim)

## Features

- Unit test support with `neotest`
- Opens project with same buffers at startup with `auto-session`
- Opens buffers at previous location with `gg/last_location` (autocmd)
- Keeps function signature visible with `nvim-treesitter-context`
- Minimal "minimap" scroll bar, including diagnostics, with `satellite`
- Buffers as "tabs" with `bufferline`
- LSP Server installation with `mason`
- LSP Server configuration with `nvim-lspconfig`
- Autoformatting with `conform`
- Better quickfix with `quicker`
- Nice TODO/Notes/etc highlighting with `todo-comments`
- Better text manipulation with `mini.ai` and `mini.surround`
- Jumping around with `flash.nvim`

## Roadmap

- [ ] Git diffing 
    - [x] Basic git diff (against HEAD)
    - [ ] Select branch/commit (for now: `:DiffviewOpen origin/main` works)
- [ ] Clean up all plugins
  - [x] lsp.lua
  - [x] telescope.lua (removed, so yay!)
  - [x] try to decouple lsp config and mason
  - [ ] treesitter.lua
- [ ] Open Help in floating
- [ ] Menu system! (Maybe a common way to add keymaps that also can add it to a menu structure?)
- [ ] Clean up keymaps
- [ ] Figure out `:messages` (might have gotten borked after removing noice)
- [ ] Function/symbol grep
- [ ] Recent picker doesn't show recently closed. Try to make it show recently edited buffers?
- [ ] Snippets (e.g. native or something like luasnips or mini.snippets) [Native ref](https://www.reddit.com/r/neovim/comments/1cxfhom/builtin_snippets_so_good_i_removed_luasnip/)
    - If still using blink, consider: 
    ```lua
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },
- [ ] Proper debugging
    ```

## Maybe

- [ ] Proper spell checker in code / comments (that doesn't give red on correctly spelled variable names)
- [ ] Github integration ?
- [ ] Task manager (for both short-term things like make/just scripts, but also things like bacon)
- [ ] Maybe the ability to move windows around

