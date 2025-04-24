local unmap_lsp_keymaps

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("gg/keymaps", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    local which = require "which-key"

    local editor = require "functionality.editor"
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
    which.add { "<leader>cr", group = "[R]efactor" }
    vim.keymap.set({ "n", "x" }, "<leader>crn", refactor.rename, { desc = "Rename", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>cre", refactor.extract_func, { desc = "Extract Function", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crf", refactor.extract_func_to_file, { desc = "Extract Function to File", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crv", refactor.extract_var, { desc = "Extract Variable", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crI", refactor.inline_func, { desc = "Inline Function", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>cri", refactor.inline_var, { desc = "Inline Variable", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crbb", refactor.extract_block, { desc = "Extract Block", expr = true })
    vim.keymap.set({ "n", "x" }, "<leader>crbf", refactor.extract_block_to_file, { desc = "Extract Block to File", expr = true })

    -- H1: Find keymaps
    which.add { "<leader>f", group = "[F]ind" }

    vim.keymap.set("n", "<leader><leader>", Snacks.picker.buffers, { desc = "Search open buffers" })
    vim.keymap.set("n", "<leader>/", Snacks.picker.smart, { desc = "Smart Find Files" })
    vim.keymap.set("n", "<leader>fr", Snacks.picker.resume, { desc = "Resume last search" })
    vim.keymap.set("n", "<leader>ff", search.file_picker, { desc = "Search files" })
    vim.keymap.set("n", "<leader>fo", Snacks.picker.recent, { desc = "Search recent files" })
    vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Search help" })
    vim.keymap.set("n", "<leader>fg", search.grep, { desc = "Search with grep" })
    vim.keymap.set("n", "<leader>fp", search.grep_plugin_files, { desc = "[S]earch neovim [P]lugin code files" })

    -- H1: LSP and Treesitter keymaps
    which.add { "<leader>l", group = "[L]SP" }

    -- Jumpy jumps
    vim.keymap.set({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })
    vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Go to definitions" })
    vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { desc = "Go to declarations" })
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "Go to references" })
    vim.keymap.set("n", "gi", Snacks.picker.lsp_implementations, { desc = "Go to implementations" })
    vim.keymap.set("n", "gt", Snacks.picker.lsp_type_definitions, { desc = "Go to type definitions" })
    vim.keymap.set("n", "gc", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "Go to context" })

    -- Selecty selects
    vim.keymap.set({ "o", "x" }, "aq", textobjs.select_outer_quote, { desc = "outer quotes" })
    vim.keymap.set({ "o", "x" }, "iq", textobjs.select_inner_quote, { desc = "outer quotes" })

    -- Misc
    vim.keymap.set("n", "<leader>lr", lsp_funcs.restart_lsp, { desc = "LSP Restart" })
    vim.keymap.set("n", "<leader>ls", Snacks.picker.lsp_symbols, { desc = "Find LSP symbols" })
    vim.keymap.set("n", "<leader>lS", Snacks.picker.lsp_workspace_symbols, { desc = "Find LSP workspace symbols" })

    vim.keymap.set("n", "<D-w>", Snacks.bufdelete.delete, { desc = "Close buffer" })
    vim.keymap.set("n", "<D-S-w>", Snacks.bufdelete.other, { desc = "Close all other buffers" })

    -- H1: Tests keymaps
    which.add { "<leader>t", group = "[T]ests" }

    vim.keymap.set("n", "<leader>to", tests.open_test, { desc = "Open test panels" })
    vim.keymap.set("n", "<leader>tn", tests.test_nearest, { desc = "Run nearest test" })

    -- H1: Git keymaps
    which.add { "<leader>g", group = "[G]it" }

    vim.keymap.set("n", "<leader>gb", Snacks.git.blame_line, { desc = "[G]it [B]lame" })
    vim.keymap.set("n", "<leader>go", Snacks.gitbrowse.open, { desc = "[G]it [O]pen" })
    vim.keymap.set("n", "<leader>gd", require("diffview").open, { desc = "Git diff view" })

    -- H2: Git pickers
    vim.keymap.set("n", "<leader>gfb", Snacks.picker.git_branches, { desc = "Find Git branches" })
    vim.keymap.set("n", "<leader>gfl", Snacks.picker.git_log, { desc = "Find Git log" })
    vim.keymap.set("n", "<leader>gfs", Snacks.picker.git_status, { desc = "Find Git status" })
    vim.keymap.set("n", "<leader>gft", Snacks.picker.git_stash, { desc = "Find Git stash" })
    vim.keymap.set("n", "<leader>gfh", Snacks.picker.git_diff, { desc = "Find Git diff (hunks)" })
    vim.keymap.set("n", "<leader>gfl", Snacks.picker.git_log_file, { desc = "Find Git log file" })

    -- H1: Notifications keymaps
    which.add { "<leader>n", group = "[N]otifications" }

    vim.keymap.set("n", "<leader>nh", Snacks.notifier.show_history, { desc = "Show notifications history" })
    vim.keymap.set("n", "<leader>nc", Snacks.notifier.hide, { desc = "Close notifications" })

    vim.keymap.set({ "n", "o", "x" }, "<CR>", require("flash").jump, { desc = "Go Flash!" })

    which.add { "<leader>A", group = "[A]I" }
    vim.keymap.set("n", "<leader>AI", function()
      require("CopilotChat").open()
    end, { desc = "AI" })

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

    -- Keymaps that only make sense inside the notes
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      pattern = "/Users/gg/Library/Mobile Documents/iCloud~md~obsidian/Documents/gg-brain/*.md",
      callback = function()
        vim.keymap.set("n", "<leader>bl", ggbrain.show_backlinks, { desc = "Show backlinks", buffer = true })
        vim.keymap.set("n", "gd", ggbrain.follow_link, { desc = "Go to definition", buffer = true })
        vim.keymap.set("n", "<leader>bt", ggbrain.insert_template, { desc = "Insert template", buffer = true })
      end,
    })
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
