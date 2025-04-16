local multi_keymaps = require "utils.multi_keymaps"

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("gg/keymaps", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Search open buffers" })
    vim.keymap.set("n", "<leader>/", Snacks.picker.smart, { desc = "Smart Find Files" })
    vim.keymap.set("n", "<leader>fr", Snacks.picker.resume, { desc = "Resume last search" })
    vim.keymap.set("n", "fE", Snacks.picker.explorer, { desc = "Open Explorer" })

    -- stylua: ignore
    vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files { hidden = true } end, { desc = "Search files" })
    vim.keymap.set("n", "<leader>fo", Snacks.picker.recent, { desc = "Search recent files" })
    vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Search help" })
    vim.keymap.set("n", "<leader>fg", function()
      Snacks.picker.grep { hidden = true }
    end, { desc = "Search with grep" })
    vim.keymap.set("n", "<leader>fp", function()
      Snacks.picker.grep {
        dirs = { vim.fs.joinpath(vim.fn.stdpath "data", "lazy") },
      }
    end, { desc = "[S]earch neovim [P]lugin code files" })

    vim.keymap.set("n", "<leader>G", function()
      Snacks.picker.select({
        {
          text = "Git diff view",
          on_select = function()
            require("diffview").open {}
          end,
        },
        {
          text = "Git Branches",
          on_select = Snacks.picker.git_branches,
        },
        {
          text = "Git Log",
          on_select = Snacks.picker.git_log,
        },
        {
          text = "Git Status",
          on_select = Snacks.picker.git_status,
        },
        {
          text = "Git Stash",
          on_select = Snacks.picker.git_stash,
        },
        {
          text = "Git Diff (Hunks)",
          on_select = Snacks.picker.git_diff,
        },
        {
          text = "Git Log File",
          on_select = Snacks.picker.git_log_file,
        },
      }, {
        prompt = "Select a git command",
        format_item = function(item)
          return item.text
        end,
      }, function(item)
        item.on_select()
      end)
    end, { desc = "Git pickers" })

    -- LSP
    vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { desc = "Go to definitions" })
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { desc = "Go to references" })
    vim.keymap.set("n", "gi", Snacks.picker.lsp_implementations, { desc = "Go to implementations" })
    vim.keymap.set("n", "gt", Snacks.picker.lsp_type_definitions, { desc = "Go to type definitions" })

    vim.keymap.set("n", "<leader>E", function()
      MiniFiles.open(vim.api.nvim_buf_get_name(0)) -- Focus on current file
      MiniFiles.reveal_cwd() -- Opens the full path down to project root
    end, { desc = "Open MiniFiles" })

    vim.keymap.set("n", "<D-w>", Snacks.bufdelete.delete, { desc = "Close buffer" })
    vim.keymap.set("n", "<D-S-w>", Snacks.bufdelete.other, { desc = "Close all other buffers" })

    --
    --       -- Jumpy jumps (LSP)
    --       { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    --       { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    --       { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    --       { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    --       { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto [T]ype Definition" },
    --       { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    --       { "gs", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace [S]ymbols" },
    --
    --       -- Git
    --       { "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame"},
    --       { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "[G]it [O]pen" },
    --
    --       -- Terminal
    --       { "<D-T>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    --
    --       -- Notifier
    --       { "<leader>nh", function() Snacks.notifier.show_history() end },
    --       { "<leader>nc", function() Snacks.notifier.hide() end },
    --
    --       -- Explorer
    --       { "<leader>E", function() Snacks.explorer.open() end },
    --
    --       -- Zen
    --       { "<leader>zz", function() Snacks.zen.zen() end, desc = "Zen Mode" },

    -- Plugin related
    multi_keymaps.add("n", "<Esc>", function()
      if MiniFiles.get_explorer_state() then
        MiniFiles.close()
      end
    end)

    vim.keymap.set({ "n", "o", "x" }, "s", require("flash").jump, { desc = "Go Flash!" })

    vim.keymap.set("n", "<leader>AI", function()
      require("CopilotChat").open()
    end, { desc = "AI" })

    vim.keymap.set("n", "<leader>cf", function() end, { desc = "Format buffer" })
  end,
})

-- file/buffer stuff
vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save file" })

vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })

-- quit
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit" })

-- clear search results
multi_keymaps.add("n", "<Esc>", function()
  vim.cmd "nohlsearch"
end)

vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent current line" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Un-indent current line" })

vim.keymap.set("v", "<TAB>", ">gv", { desc = "Indent selected text" })
vim.keymap.set("v", "<S-TAB>", "<gv", { desc = "Indent selected text" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cdq", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>cdn", function()
  vim.diagnostic.jump { diagnostic = vim.diagnostic.get_next() }
end, { desc = "Go to [N]ext [D]iagnostics message" })
vim.keymap.set("n", "<cleader>cdp", function()
  vim.diagnostic.jump { diagnostic = vim.diagnostic.get_prev() }
end, { desc = "Go to [P]revious [D]iagnostics message" })

-- Keybindings to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Folding
vim.keymap.set("n", "ﬁ", "zo", { desc = "Open fold" })
vim.keymap.set("n", "˛", "zc", { desc = "Close fold" })
