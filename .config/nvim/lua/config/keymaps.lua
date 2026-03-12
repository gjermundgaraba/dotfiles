local map = require "utils.keymapper"

local function unmap_default_keymaps()
  -- Remove conflicting Neovim defaults
  -- To find overlapping keymaps, use: `:checkhealth which-key`
  vim.keymap.del("n", "grr")
  vim.keymap.del("n", "grn")
  vim.keymap.del("n", "gra")
  vim.keymap.del("n", "gri")
  vim.keymap.del("n", "gcc")
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("gg/keymaps", { clear = true }),
  pattern = "LazyDone",
  callback = function()
    unmap_default_keymaps()

    -- ============================================================================
    -- Which-key group registrations
    -- ============================================================================
    map.group("<leader>c", "[C]ode")
    map.group("<leader>cr", "[R]efactor")
    map.group("<leader>s", "[S]earch")
    map.group("<leader>l", "[L]SP")
    map.group("<leader>g", "[G]it")
    map.group("<leader>gs", "[S]earch")
    map.group("<leader>k", "[K]eymaps")
    map.group("<leader>A", "[A]I")
    map.group("<leader><M-D-t>", "Terminal")
    map.register_groups()

    -- ============================================================================
    -- Editor keymaps (no plugin dependencies)
    -- ============================================================================

    -- Save & Quit
    map.map({ "i", "n" }, "<D-s>", "<cmd>write<CR>", { desc = "Save file" })
    map.map({ "i", "n" }, "<F13>", "<cmd>write<CR>", { desc = "Save file" })
    map.nmap("<leader>q", ":qa<CR>", { desc = "Quit" })
    map.nmap("<C-q>", function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        once = true,
        callback = function()
          -- Spawn a background job that waits for nvim to exit, then exits the shell
          vim.fn.jobstart({ "sh", "-c", "sleep 0.1 && exit" }, {
            detach = true,
            on_exit = function() end
          })
        end,
      })
      vim.cmd('qa!')
    end, { desc = "Quit it and hit it" })

    -- Clear highlights
    map.nmap("<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

    -- Buffer navigation
    map.nmap("<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    map.nmap("<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

    -- Folding (opt+l, opt+h)
    map.nmap("ﬁ", "zo", { desc = "Open fold" })
    map.nmap("˛", "zc", { desc = "Close fold" })

    -- Window navigation
    map.map({ "n", "t" }, "<C-h>", function() vim.cmd.wincmd "h" end, { desc = "Focus left window" })
    map.map({ "n", "t" }, "<C-l>", function() vim.cmd.wincmd "l" end, { desc = "Focus right window" })
    map.nmap("<C-j>", function() vim.cmd.wincmd "j" end, { desc = "Focus lower window" })
    map.map({ "n", "t" }, "<C-k>", function() vim.cmd.wincmd "k" end, { desc = "Focus upper window" })

    -- Window resizing
    map.nmap("<C-S-0>", "<C-w>=", { desc = "Equalize windows" })
    map.nmap("<C-S-h>", "5<C-w><", { desc = "Decrease width" })
    map.nmap("<C-S-l>", "5<C-w>>", { desc = "Increase width" })
    map.nmap("<C-S-j>", "5<C-w>-", { desc = "Decrease height" })
    map.nmap("<C-S-k>", "5<C-w>+", { desc = "Increase height" })

    -- Jump list (explicit to avoid conflicts)
    map.nmap("<C-o>", "<C-o>", { desc = "Jump back" })
    map.nmap("<C-i>", "<C-i>", { desc = "Jump forward" })

    -- Indentation
    map.nmap("<Tab>", ">>", { desc = "Indent line" })
    map.nmap("<S-Tab>", "<<", { desc = "Un-indent line" })
    map.vmap("<TAB>", ">gv", { desc = "Indent selection" })
    map.vmap("<S-TAB>", "<gv", { desc = "Un-indent selection" })

    -- ============================================================================
    -- Diagnostics (vim.diagnostic builtin)
    -- ============================================================================
    map.leader("cdq", function()
      vim.diagnostic.setqflist { open = true, title = "Diagnostics (all buffers)" }
    end, { desc = "Diagnostics to Quickfix" })

    map.leader("cdn", function()
      local next = vim.diagnostic.get_next()
      if next then
        vim.diagnostic.jump { diagnostic = next }
      else
        vim.notify("No next diagnostic", vim.log.levels.INFO)
      end
    end, { desc = "Next diagnostic" })

    map.leader("cdN", function()
      local prev = vim.diagnostic.get_prev()
      if prev then
        vim.diagnostic.jump { diagnostic = prev }
      else
        vim.notify("No previous diagnostic", vim.log.levels.INFO)
      end
    end, { desc = "Previous diagnostic" })

    -- ============================================================================
    -- LSP builtins (not using fzf-lua)
    -- ============================================================================
    map.map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })
    map.map({ "n", "x" }, "<leader>crn", vim.lsp.buf.rename, { desc = "Rename" })
    map.leader("lr", function() require("utils.lsp").restart() end, { desc = "Restart LSP" })

    -- ============================================================================
    -- Treesitter
    -- ============================================================================
    map.nmap("gc", function()
      require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "Go to context" })

    -- ============================================================================
    -- Format
    -- ============================================================================
    map.leader("cf", function() require("conform").format() end, { desc = "Format buffer" })

    -- ============================================================================
    -- Which-key
    -- ============================================================================
    map.leader("ks", function() require("which-key").show() end, { desc = "Show keymaps" })
    map.leader("kl", function() require("which-key").show { loop = true } end, { desc = "Keymaps (loop mode)" })

    -- ============================================================================
    -- Terminal
    -- ============================================================================
    map.tmap("<esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

    -- ============================================================================
    -- AI (Copilot)
    -- ============================================================================
    map.leader("AI", function() require("CopilotChat").open() end, { desc = "Open Copilot Chat" })

    -- Accept suggestion (intentionally overrides indent in i/n modes)
    map.map({ "i", "n" }, "<S-TAB>", function()
      require("copilot.suggestion").accept()
    end, { desc = "Accept AI suggestion", override = true })

    map.map({ "i", "n" }, "<D-S-L>", function()
      require("copilot.suggestion").accept_word()
    end, { desc = "Accept AI suggestion word" })

    map.map({ "i", "n" }, "<F17>", function()
      require("copilot.suggestion").accept_word()
    end, { desc = "Accept AI suggestion word" })

    -- Tab: Accept if visible, else normal Tab
    map.map({ "i", "n" }, "<TAB>", function()
      local copilot = require "copilot.suggestion"
      if copilot.is_visible() then
        return copilot.accept()
      end
      return "<Tab>"
    end, { desc = "Accept AI or indent", expr = true, override = true })

    -- ============================================================================
    -- Quickfix
    -- ============================================================================
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        map.nmap("<leader>r", function() require("quicker").refresh() end, { buffer = 0, desc = "Refresh quickfix" })
      end,
    })
  end,
})
