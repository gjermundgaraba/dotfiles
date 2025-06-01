local unmap_lsp_keymaps

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("gg/keymaps", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    local which = require "which-key"

    local editor = require "functionality.editor"
    local tabs = require "functionality.tabs"
    local diagnostic = require("functionality.code").diagnostic
    local lsp_funcs = require("functionality.code").lsp
    local refactor = require("functionality.code").refactor
    local search = require "functionality.search"
    local tests = require "functionality.tests"
    local textobjs = require "functionality.textobjects"
    local ggbrain = require "functionality.ggbrain"

    unmap_lsp_keymaps()

    -- H1: General keymaps
    vim.keymap.set({ "i", "n" }, "<D-s>", editor.save, { desc = "Save file" })
    vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit" })

    -- File explorer
    vim.keymap.set("n", "<leader>em", editor.open_file_system_manager, { desc = "Open File Manager" })
    vim.keymap.set("n", "<leader>ee", editor.open_explorer, { desc = "Open File Explorer" })
    vim.keymap.set("n", "<leader>E", editor.open_explorer, { desc = "Open File Explorer" })

    vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

    -- Folding
    vim.keymap.set("n", "ﬁ", "zo", { desc = "Open fold" }) -- opt+l
    vim.keymap.set("n", "˛", "zc", { desc = "Close fold" }) -- opt+h

    -- Keybindings to make split navigation easier.
    vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
    vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
    vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
    vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

    vim.keymap.set("n", "<C-S-0>", "<C-w>=", { desc = "Equalize window size" })
    vim.keymap.set("n", "<C-S-h>", "5<C-w><", { desc = "Decrease window width" })
    vim.keymap.set("n", "<C-S-l>", "5<C-w>>", { desc = "Increase window width" })
    vim.keymap.set("n", "<C-S-j>", "5<C-w>-", { desc = "Decrease window height" })
    vim.keymap.set("n", "<C-S-k>", "5<C-w>+", { desc = "Increase window height" })

    -- Not sure why this is necessary, but without it, it indents some shit instead 🤷
    vim.keymap.set("n", "<C-o>", "<C-o>", { desc = "Jump back" })
    vim.keymap.set("n", "<C-i>", "<C-i>", { desc = "Jump forward" })

    -- Whatever needs clearing
    vim.keymap.set("n", "<Esc>", editor.clear)

    -- indentation
    vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent current line" })
    vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Un-indent current line" })

    vim.keymap.set("v", "<TAB>", ">gv", { desc = "Indent selected text" })
    vim.keymap.set("v", "<S-TAB>", "<gv", { desc = "Indent selected text" })

    -- H1: Code keymaps
    which.add { "<leader>c", group = "[C]ode" }

    vim.keymap.set("n", "<leader>cf", require("conform").format, { desc = "Format buffer" })

    -- Diagnostic specific codemaps
    vim.keymap.set("n", "<leader>cdq", diagnostic.open_all_in_qf, { desc = "Diagnostics → Quickfix" })
    vim.keymap.set("n", "<leader>cdn", diagnostic.go_to_next, { desc = "Go to [N]ext [D]iagnostics message" })
    vim.keymap.set("n", "<leader>cdN", diagnostic.go_to_prev, { desc = "Go to [P]revious [D]iagnostics message" })

    -- refactor
    -- TODO: Maybe these don't need to be a separate group?
    -- Or maybe just use leader r?
    which.add { "<leader>cr", group = "[R]efactor" }
    vim.keymap.set({ "n", "x" }, "<leader>crn", refactor.rename, { desc = "Rename", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>cre", refactor.extract_func, { desc = "Extract Function", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crf", refactor.extract_func_to_file, { desc = "Extract Function to File", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crv", refactor.extract_var, { desc = "Extract Variable", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crI", refactor.inline_func, { desc = "Inline Function", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>cri", refactor.inline_var, { desc = "Inline Variable", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crbb", refactor.extract_block, { desc = "Extract Block", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crbf", refactor.extract_block_to_file, { desc = "Extract Block to File", expr = true })

    -- H1: Search keymaps
    which.add { "<leader>s", group = "[S]earch" }
    vim.keymap.set("n", "<leader><leader>", search.open_buffers, { desc = "Search open buffers" })
    vim.keymap.set("n", "<leader>sc", search.recent_files, { desc = "Continue search" })
    vim.keymap.set("n", "<leader>sr", search.recent_files, { desc = "Search recent files" })
    vim.keymap.set("n", "<leader>sf", search.file_picker, { desc = "Search files" })
    vim.keymap.set("n", "<leader>sh", search.help, { desc = "Search help" })
    vim.keymap.set("n", "<leader>sg", search.live_grep, { desc = "Search with grep" })
    vim.keymap.set("n", "<leader>sp", search.grep_plugin_files, { desc = "[S]earch neovim [P]lugin code files" })

    -- H1: LSP and Treesitter keymaps
    which.add { "<leader>l", group = "[L]SP" }

    -- Jumpy jumps
    vim.keymap.set({ "i", "n" }, "<C-s>", lsp_funcs.show_signature, { desc = "Signature help" })
    vim.keymap.set("n", "gd", lsp_funcs.defintions, { desc = "Go to definitions" })
    vim.keymap.set("n", "gD", lsp_funcs.declarations, { desc = "Go to declarations" })
    vim.keymap.set("n", "ga", lsp_funcs.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "gr", lsp_funcs.references, { desc = "Go to references" })
    vim.keymap.set("n", "gi", lsp_funcs.implementations, { desc = "Go to implementations" })
    vim.keymap.set("n", "gt", lsp_funcs.type_definitions, { desc = "Go to type definitions" })
    vim.keymap.set("n", "gc", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "Go to context" })

    -- Selecty selects
    vim.keymap.set({ "o", "x" }, "aq", textobjs.select_outer_quote, { desc = "outer quotes" })
    vim.keymap.set({ "o", "x" }, "iq", textobjs.select_inner_quote, { desc = "outer quotes" })

    -- Misc
    vim.keymap.set("n", "<leader>lr", lsp_funcs.restart_lsp, { desc = "LSP Restart" })
    vim.keymap.set("n", "<leader>ls", lsp_funcs.document_symbols, { desc = "Find LSP symbols" })
    vim.keymap.set("n", "<leader>lS", lsp_funcs.live_workspace_symbols, { desc = "Find LSP workspace symbols" })

    vim.keymap.set("n", "<D-w>", tabs.close, { desc = "Close buffer" })
    vim.keymap.set("n", "<D-S-t>", tabs.undo_close, { desc = "Undo close buffer" })
    vim.keymap.set("n", "<D-S-w>", tabs.close_others, { desc = "Close all other buffers" })

    -- H1: Tests keymaps
    which.add { "<leader>t", group = "[T]ests" }

    vim.keymap.set("n", "<leader>to", tests.open_test, { desc = "Open test panels" })
    vim.keymap.set("n", "<leader>tn", tests.test_nearest, { desc = "Run nearest test" })

    -- H1: Git keymaps
    which.add { "<leader>g", group = "[G]it" }

    vim.keymap.set("n", "<leader>gb", Snacks.git.blame_line, { desc = "[G]it [B]lame" })
    vim.keymap.set({ "n", "v" }, "<leader>go", Snacks.gitbrowse.open, { desc = "[G]it [O]pen" })
    vim.keymap.set("n", "<leader>gd", require("diffview").open, { desc = "Git diff view" })

    -- H2: Git pickers
    vim.keymap.set("n", "<leader>gsb", search.git_branches, { desc = "Search Git branches" })
    vim.keymap.set("n", "<leader>gsb", search.git_blame, { desc = "Search Git blame" })
    vim.keymap.set("n", "<leader>gsl", search.git_log, { desc = "Search Git log" })
    vim.keymap.set("n", "<leader>gsh", search.git_diff, { desc = "Search Git diff (hunks)" })

    -- H1: Keymap keymaps
    which.add { "<leader>k", group = "[K]eymaps" }
    vim.keymap.set("n", "<leader>ks", require("which-key").show, { desc = "Show keymaps" })
    vim.keymap.set("n", "<leader>kl", function()
      require("which-key").show { loop = true }
    end, { desc = "Show keymaps in loop mode (ESC to exit)" })

    -- H1: ggbrain keymaps
    which.add { "<leader>b", group = "ggbrain" }

    -- Keymaps that make sense everywhere
    vim.keymap.set("n", "<leader>bb", ggbrain.open_index, { desc = "Go to brain index" })
    vim.keymap.set("n", "<leader>bn", ggbrain.new_note, { desc = "Create new note" })
    vim.keymap.set("n", "<leader>bg", ggbrain.search, { desc = "Grep search notes" })
    vim.keymap.set("n", "<leader>bf", ggbrain.find_note, { desc = "Find note" })
    vim.keymap.set("n", "<leader>bd", ggbrain.todos, { desc = "Show todos" })

    -- Keymaps that only make sense inside the notes
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      pattern = "/Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain/*.md",
      callback = function()
        vim.keymap.set("n", "<leader>bl", ggbrain.show_backlinks, { desc = "Show backlinks", buffer = true })
        vim.keymap.set("n", "gd", ggbrain.follow_link, { desc = "Go to definition", buffer = true })
        vim.keymap.set("n", "<leader>bt", ggbrain.insert_template, { desc = "Insert template", buffer = true })
      end,
    })

    -- H1: AI keymaps
    which.add { "<leader>A", group = "[A]I" }
    vim.keymap.set("n", "<leader>AI", function()
      require("CopilotChat").open()
    end, { desc = "AI" })

    -- H1: Other keymaps and setup
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        vim.keymap.set("n", "<leader>r", function()
          require("quicker").refresh()
        end, { buffer = 0, desc = "Refresh quickfix list" })
      end,
    })
    vim.keymap.set({ "n", "o", "x" }, "<leader>f", require("flash").jump, { desc = "Go Flash!" })
  end,
})

-- Used to unmap unwanted keymaps from Neovim and plugins
-- To find overlapping keymaps, use: `:checkhealth which-key`
function unmap_lsp_keymaps()
  vim.keymap.del("n", "grr")
  vim.keymap.del("n", "grn")
  vim.keymap.del("n", "gra")
  vim.keymap.del("n", "gri")

  vim.keymap.del("n", "gcc")
end
