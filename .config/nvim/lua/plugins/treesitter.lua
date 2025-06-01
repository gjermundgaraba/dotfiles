-- Treesitter and friends (textobjects, even though they're not all directly treesitter related)
return {
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false, -- does not support lazy loading
    opts = {
      ensure_installed = {
        "bash",
        "diff",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query", -- treesitter query language
        "vim",
        "vimdoc",
        "yaml",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "rust",
      },
      sync_install = false,
      auto_install = true, -- Automatically install missing parsers when entering buffer
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<D-S-l>",
          node_incremental = "<D-S-l>",
          node_decremental = "<D-S-h>",
          -- scope_incremental seems to not be useful for me
        },
      },
      refactor = {
        -- NOTE: if this turns out to be slow, look into: https://github.com/RRethy/vim-illuminate or similar
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = true,
        },
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = { -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
          },
          lookahead = true,
        },
      },
    },
  },
  { -- show top level function signature or whatever in long blocks
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 5,
    },
  },
  { -- Surround textobject motions
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    opts = {},
  },
  { -- More textobjects (mostly for a/i)
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = false,
      },
    },
  },
}
