return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    config = function(_, opts)
      local local_plugin_folder = vim.fn.expand "$HOME/code/neovim-plugins"
      local handle = vim.loop.fs_scandir(local_plugin_folder)
      while handle do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then
          break
        end
        if type == "directory" then
          table.insert(opts.library, local_plugin_folder .. "/" .. name)
        end
      end

      require("lazydev").setup(opts)
    end,
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
