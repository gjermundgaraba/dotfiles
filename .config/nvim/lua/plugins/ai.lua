local function get_opencodenvim_actions()
  local oc = require("opencode")

  local function repo_path_to_file()
    return vim.fn.expand("%:.")
  end

  return {
    toggle = function()
      oc.toggle()
    end,
    add_file_to_context = function()
      oc.prompt("@" .. repo_path_to_file())
    end,
    add_path_to_context = function()
      oc.prompt(repo_path_to_file())
    end,
    add_selection_to_context = function()
      return oc.operator("@this")
    end,
  }
end

local function get_opencontext_actions()
  local opencontext = require("opencontext")
  return {
    yank_file_path = function()
      local file_path = opencontext.context.get_file_path()
      vim.fn.setreg("+", file_path)
      vim.notify("Yanked file path: " .. file_path, vim.log.levels.INFO, {
        timeout = 1000,
      })
    end,
    yank_context_file_path = function()
      local context_file_path = opencontext.context.get_context_file_path()
      vim.fn.setreg("+", context_file_path)
      vim.notify("Yanked context file path: " .. context_file_path, vim.log.levels.INFO)
    end,
    yank_context_range = function()
      local context_range = opencontext.context.get_context_range()
      vim.fn.setreg("+", context_range)
      vim.notify("Yanked context range: " .. context_range, vim.log.levels.INFO)
    end,
  }
end



return {
  {
    "gjermundgaraba/opencontext.nvim",
    dev = true,
    config = function()
      local actions = get_opencontext_actions()
      vim.keymap.set("n", "<leader>ya", actions.yank_context_file_path, { desc = "Yank context file path to clipboard" })
      vim.keymap.set("x", "<leader>ya", actions.yank_context_range,
        { expr = true, desc = "Yank context range to clipboard" })
      vim.keymap.set("n", "<leader>yf", actions.yank_file_path, { desc = "Yank file path to clipboard" })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<S-TAB>",
            accept_word = "<D-L>",
            next = "<S-Right>",
            prev = "<S-Left>",
          },
        },
      }
    end,
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      {
        "folke/snacks.nvim",
        opts = {
          input = {},
          picker = {},
          terminal = {}
        }
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
        provider = {
          -- enabled = "ghostty",
          -- ghostty = {
          -- },
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      local actions = get_opencodenvim_actions()

      vim.keymap.set({ "n", "t" }, "<C-.>", actions.toggle, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<leader>aa", actions.add_file_to_context, { desc = "Add file to opencode" })
      vim.keymap.set("x", "<leader>aa", actions.add_selection_to_context,
        { expr = true, desc = "Add selection to opencode" })
      vim.keymap.set("n", "<leader>af", actions.add_path_to_context, { desc = "Add filename to opencode prompt" })

      -- Remap this:
      -- vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
      --   { desc = "Ask opencode" })
      -- vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
      --   { desc = "Execute opencode action…" })
      -- vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
      --   { expr = true, desc = "Add line to opencode" })
      -- vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
      --   { desc = "opencode half page up" })
      -- vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
      --   { desc = "opencode half page down" })
      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  }
}
