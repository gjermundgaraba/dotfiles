vim.lsp.enable "gopls"
vim.lsp.enable "gh_actions_ls"
vim.lsp.enable "lua_ls"
vim.lsp.enable "solidity_ls"
vim.lsp.enable "jsonls"

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      buildFlags = { "-tags=e2e" },
    },
  },
})
