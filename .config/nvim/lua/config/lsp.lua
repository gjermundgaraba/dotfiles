vim.lsp.enable "gopls"
vim.lsp.enable "gh_actions_ls"
vim.lsp.enable "lua_ls"
vim.lsp.enable "solidity_ls"
vim.lsp.enable "jsonls"
vim.lsp.enable "copilot"
vim.lsp.enable "ts_ls"

vim.lsp.config("jsonls", {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      buildFlags = { "-tags=e2e" },
    },
  },
})
