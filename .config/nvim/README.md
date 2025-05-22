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
### Now

- [x] Capture notes from anywhere
- [x] Flash?
- [ ] Fix treesitter-context
- [ ] Tree-based (using nui-components) notes from index
- [ ] Captured notes are indexed
- [ ] Set up treesitter-textobjects and surround keymaps
- [ ] Recent picker doesn't show recently closed. Try to make it show recently edited buffers?
- [ ] Make sure neotest works
- [ ] Delete buffers from my picker list

### Later

- [ ] Make paste a separate undo action
- [ ] Reconsider fzf as my picker
- [ ] Git diffing with selecting a branch (for now: `:DiffviewOpen origin/main` works)
- [ ] Symbol explorer (foldable things thingy to find stuff)
- [ ] Show lsp in status bar
- [ ] Move buffers in `bufferline`
- [ ] Figure out `:messages` (might have gotten borked after removing noice)
- [ ] More plugins that could be replaced with native solutions? 
    - Inspo: [blog post about neovim without plugins 2025](https://boltless.me/posts/neovim-config-without-plugins-2025/)
- [ ] Make some Neovim UI stuff 
    - [OXY2DEV/ui.nvim](https://github.com/OXY2DEV/ui.nvim)
    - [grapp-dev/nui-components.nvim](https://github.com/grapp-dev/nui-components.nvim)
    - [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
    - https://www.reddit.com/r/neovim/comments/1k8upba/release_uinvim/
- [ ] Toggles
    - [ ] Toggle Harper
- [ ] Keymap discoverability with menu system
- [ ] Make sure debugging works
- [ ] Make git stuff work in my neovim config folder
- [ ] See if there is stuff from [ray-x/go.nvim](https://github.com/ray-x/go.nvim) that I should adopt

### Plugins to test/consider
- [ ] Hover (maybe other stuff from the same dude) [lewis6991/hover](https://github.com/lewis6991/hover.nvim)
- [ ] Subtle animations [tiny-glimmer](https://github.com/rachartier/tiny-glimmer.nvim)
- [ ] Sidebar with outline of LSP symbols [hedyhli/outline.nvim](https://github.com/hedyhli/outline.nvim)
    - [ ] Another option: [aeriel.nvim](https://github.com/stevearc/aerial.nvim)
- [ ] Treesitter split/join: [treesj](https://github.com/Wansmer/treesj)
- [ ] Useful keymaps? [unimpaired.nvim](https://github.com/tummetott/unimpaired.nvim)
- [ ] Substitution/exchange operators: [substitute.nvim](https://github.com/gbprod/substitute.nvim)
- [ ] Find and replace: [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim)
- [ ] Undo branches and visualization: [undotree](https://github.com/mbbill/undotree)
- [ ] Visualize LSP definitions/impls/etc in float: [goto-preview](https://github.com/rmagatti/goto-preview)

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
