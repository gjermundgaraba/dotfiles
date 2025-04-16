return {
  {
    -- Main LSP Configuration (to see difference between lsp and treesitter: `:help lsp-vs-treesitter`)
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP.
    },
    opts = {
      diagnostics = {
        update_in_insert = true,
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      lspconfig.gopls.setup {}
      lspconfig.gh_actions_ls.setup {}
      lspconfig.lua_ls.setup {}
      lspconfig.solidity_ls.setup {}
      lspconfig.jsonls.setup {}
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    dpendencies = { "neovim/nvim-lspconfig" },
    ft = "lua",
    opts = {
      library = {
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "mini.files", words = { "MiniFiles" } },
      },
    },
  },
}
