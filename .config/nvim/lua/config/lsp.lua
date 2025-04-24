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

vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath "config" and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
        return
      end
    end

    local lazy_path = vim.fn.expand "$HOME/.local/share/nvim/lazy"
    local library = {
      vim.env.VIMRUNTIME,
      "${3rd}/luv/library", -- Adds stuff like `vim.uv.fs_stat`
    }
    local handle = vim.loop.fs_scandir(lazy_path)
    while handle do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then
        break
      end
      if type == "directory" then
        table.insert(library, lazy_path .. "/" .. name)
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = library,
        -- or pull in all of 'runtimepath', but this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
