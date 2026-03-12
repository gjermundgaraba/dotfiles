return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function(_, opts)
      local fzf = require "fzf-lua"
      fzf.setup(opts)
      fzf.register_ui_select() -- Use fzf for vim.ui.select

      local map = require "utils.keymapper"

      -- Builtin
      map.nmap("<leader>p", fzf.builtin, { desc = "FzfLua Commands" })

      -- Search
      map.nmap("<leader><leader>", fzf.buffers, { desc = "Search open buffers" })
      map.nmap("<leader>ss", fzf.resume, { desc = "Continue search" })
      map.nmap("<leader>so", function()
        fzf.oldfiles { cwd_only = true }
      end, { desc = "Search recent files" })
      map.nmap("<leader>sf", fzf.files, { desc = "Search files" })
      map.nmap("<leader>sh", fzf.help_tags, { desc = "Search help" })
      map.nmap("<leader>sg", fzf.live_grep, { desc = "Search with grep" })
      map.nmap("<leader>sp", function()
        fzf.live_grep { search_paths = { vim.fn.stdpath "data" .. "/lazy" } }
      end, { desc = "Search plugin code" })
      map.nmap("<leader>sd", fzf.diagnostics_workspace, { desc = "Search diagnostics" })

      -- Git
      map.nmap("<leader>gsb", fzf.git_branches, { desc = "Git branches" })
      map.nmap("<leader>gsB", fzf.git_blame, { desc = "Git blame" })
      map.nmap("<leader>gsl", fzf.git_commits, { desc = "Git log" })
      map.nmap("<leader>gsh", fzf.git_diff, { desc = "Git diff" })

      -- LSP (using fzf-lua pickers)
      map.nmap("gd", fzf.lsp_definitions, { desc = "Go to definitions" })
      map.nmap("gD", fzf.lsp_declarations, { desc = "Go to declarations" })
      map.nmap("ga", fzf.lsp_code_actions, { desc = "Code actions" })
      map.nmap("gr", fzf.lsp_references, { desc = "Go to references" })
      map.nmap("gi", fzf.lsp_implementations, { desc = "Go to implementations" })
      map.nmap("gt", fzf.lsp_typedefs, { desc = "Go to type definitions" })
      map.nmap("<leader>ls", fzf.lsp_document_symbols, { desc = "Document symbols" })
      map.nmap("<leader>lS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
    end,
    opts = {
      "hide",
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      grep = {
        hidden = true,
      },
      files = {
        hidden = true,
      },
    },
  },
}
