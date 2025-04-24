local M = {}

function M.save()
  vim.cmd "write"
end

function M.open_explorer()
  MiniFiles.open(vim.api.nvim_buf_get_name(0)) -- Focus on current file
  MiniFiles.reveal_cwd() -- Opens the full path down to project root
end

function M.clear()
  M.clear_highlights()
  if MiniFiles.get_explorer_state() then
    MiniFiles.close()
  end
end

function M.clear_highlights()
  vim.cmd "nohlsearch"
end

return M
