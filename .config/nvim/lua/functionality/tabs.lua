local M = {}

local last_closed = nil

function M.close()
  Snacks.bufdelete.delete()
end

function M.close_others()
  Snacks.bufdelete.other()
end

function M.undo_close()
  vim.notify("Undo close not implemented yet", vim.log.levels.WARN)
end

return M
