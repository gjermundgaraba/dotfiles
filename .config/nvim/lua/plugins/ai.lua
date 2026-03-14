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
}
