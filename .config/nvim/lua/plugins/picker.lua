return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>p", function() require("fzf-lua").builtin() end, desc = "FzfLua Commands" },
    },
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
