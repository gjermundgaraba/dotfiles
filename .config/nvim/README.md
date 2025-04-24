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
- All keymaps in a single `keymaps.lua` file
- Simple fold visuals in the `statuscolumn`

## Roadmap

- [ ] Initial note setup
- [ ] Set up treesitter-textobjects and surround keymaps
- [ ] Recent picker doesn't show recently closed. Try to make it show recently edited buffers?
- [ ] Make sure neotest works
- [ ] Delete buffers from my picker list

## Later

- [ ] Make paste a separate undo action
- [ ] Reconsider fzf as my picker
- [ ] Git diffing with selecting a branch (for now: `:DiffviewOpen origin/main` works)
- [ ] Symbol explorer (foldable things thingy to find stuff)
- [ ] Show lsp in status bar
- [ ] Move buffers in `bufferline`
- [ ] Figure out `:messages` (might have gotten borked after removing noice)
- [ ] More plugins that could be replaced with native solutions?
- [ ] Make some Neovim UI stuff [potential starting point](https://github.com/OXY2DEV/ui.nvim)
- [ ] Toggles
    - [ ] Toggle Harper
- [ ] Keymap discoverability with menu system
- [ ] Make sure debugging works
- [ ] Make git stuff work in my neovim config folder

## Maybe

- [ ] Do I want to use some builtin terminal to avoid having a fixed terminal open?
- [ ] Abstract out pickers to make it easier to switch?
- [ ] Github integration
- [ ] Make my own `statusline` using native stuff?
- [ ] Make my own status column: [guide](https://www.reddit.com/r/neovim/comments/1djjc6q/statuscolumn_a_beginers_guide/)
- [ ] Snippets (e.g. native or something like luasnips or mini.snippets) [Native ref](https://www.reddit.com/r/neovim/comments/1cxfhom/builtin_snippets_so_good_i_removed_luasnip/)
    - If still using blink, consider: 
    ```lua
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },
    ```
- [ ] Any fun plugin I could write with the [go client](https://github.com/neovim/go-client)?
