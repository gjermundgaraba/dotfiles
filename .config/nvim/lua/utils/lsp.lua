-- LSP utilities
local M = {}

---Restart all attached LSP clients, preserving buffer attachments
function M.restart()
  local attached_clients = vim.lsp.get_clients()
  if vim.tbl_isempty(attached_clients) then
    vim.notify("No active LSP clients found.", vim.log.levels.INFO)
    return
  end

  for _, c in pairs(attached_clients) do
    local config = c.config

    local attached_buffers = {}
    for bufnr, attached in pairs(c.attached_buffers) do
      if attached then
        attached_buffers[bufnr] = true
      end
    end

    vim.notify("Stopping LSP client: " .. c.id, vim.log.levels.INFO)
    vim.lsp.stop_client(c.id)

    vim.defer_fn(function()
      vim.notify("Restarting LSP client: " .. config.name, vim.log.levels.INFO)
      local client_id = assert(vim.lsp.start(config, { attach = false }), "Failed to start LSP client")

      for bufnr, _ in pairs(attached_buffers) do
        vim.lsp.buf_attach_client(bufnr, client_id)
      end
    end, 1000)
  end
end

return M
