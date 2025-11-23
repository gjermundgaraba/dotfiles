local unmap_lsp_keymaps

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("gg/keymaps", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    local which = require "which-key"
    local copilot = require "copilot.suggestion"

    local editor = require "functionality.editor"
    local tabs = require "functionality.tabs"
    local diagnostic = require("functionality.code").diagnostic
    local lsp_funcs = require("functionality.code").lsp
    local refactor = require("functionality.code").refactor
    local search = require "functionality.search"
    local textobjs = require "functionality.textobjects"
    local terminal = require "functionality.terminal"
    local ai = require "functionality.ai"

    unmap_lsp_keymaps()

    -- H1: General keymaps

    vim.keymap.set({ "i", "n" }, "<D-s>", editor.save, { desc = "Save file" })

    vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit" })

    -- File explorer
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

    -- H1: Search keymaps
    which.add { "<leader>s", group = "[S]earch" }
    vim.keymap.set("n", "<leader><leader>", search.open_buffers, { desc = "Search open buffers" })
    vim.keymap.set("n", "<leader>ss", search.resume, { desc = "Continue search" })
    vim.keymap.set("n", "<leader>so", search.recent_files, { desc = "Search recent files" })
    vim.keymap.set("n", "<leader>sf", search.file_picker, { desc = "Search files" })
    vim.keymap.set("n", "<leader>sh", search.help, { desc = "Search help" })
    vim.keymap.set("n", "<leader>sg", search.live_grep, { desc = "Search with grep" })
    vim.keymap.set("n", "<leader>sp", search.grep_plugin_files, { desc = "[S]earch neovim [P]lugin code files" })
    vim.keymap.set("n", "<leader>sd", search.workspace_diagnostics, { desc = "Search workspace diagnostics" })

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

    -- H1: Terminal keymaps
    vim.keymap.set({ "n", "t" }, "<M-D-t>", terminal.toggle_default_terminal, { desc = "Toggle default terminal" })
    which.add { "<leader><M-D-t>", group = "Terminal" }
    vim.keymap.set("n", "<leader><M-D-t>g", terminal.toggle_git_terminal, { desc = "Toggle git terminal" })

    -- H2: In-terminal keymaps
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Normal mode in terminal" })

    -- H1: AI keymaps
    which.add { "<leader>A", group = "[A]I" }
    vim.keymap.set("n", "<leader>AI", function()
      require("CopilotChat").open()
    end, { desc = "AI" })
    vim.keymap.set({ "i", "n" }, "<S-TAB>", ai.accept, { desc = "Accept AI suggestion" })
    vim.keymap.set({ "i", "n" }, "<D-S-L>", ai.accept_word, { desc = "Accept AI suggestion next word" })
    vim.keymap.set({ "i", "n" }, "<TAB>", function()
      if not require("sidekick").nes_jump_or_apply() then
        if copilot.has_next() then
          return copilot.accept()
        end

        return "<Tab>" -- fallback to normal tab
      end
    end, { desc = "Goto/Apply Next Edit Suggestion", expr = true })

    --       "<tab>",
    --       function()
    --         -- if there is a next edit, jump to it, otherwise apply it if any
    --         if not require("sidekick").nes_jump_or_apply() then
    --           return "<Tab>" -- fallback to normal tab
    --         end
    --       end,
    --       expr = true,
    --       desc = "Goto/Apply Next Edit Suggestion",


    -- H1: Other keymaps and setup
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        vim.keymap.set("n", "<leader>r", function()
          require("quicker").refresh()
        end, { buffer = 0, desc = "Refresh quickfix list" })
      end,
    })

    -- H1: Warp hacks (used in conjunction with Karabiner-Elements)
    -- TODO: Create a multi-keymap function to make this cleaner
    vim.keymap.set({ "i", "n" }, "<F13>", editor.save, { desc = "Save file" })
    vim.keymap.set("n", "<F14>", tabs.close, { desc = "Close buffer" })
    vim.keymap.set("n", "<F15>", tabs.undo_close, { desc = "Undo close buffer" })
    vim.keymap.set("n", "<F16>", tabs.close_others, { desc = "Close all other buffers" })
    vim.keymap.set({ "i", "n" }, "<F17>", ai.accept_word, { desc = "Accept AI suggestion next word" })
    vim.keymap.set({ "i", "n", "t" }, "<F18>", terminal.toggle_default_terminal, { desc = "Toggle default terminal" })
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
