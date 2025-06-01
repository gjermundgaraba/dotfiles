local M = {}

local fzf = require "fzf-lua"
fzf.register_ui_select()

-- H1: Diagnostics
M.diagnostic = {}
function M.diagnostic.open_all_in_qf()
  vim.diagnostic.setqflist {
    open = true,
    title = "Diagnostics (all buffers)",
  }
end

function M.diagnostic.go_to_next()
  local next = vim.diagnostic.get_next()
  if next ~= nil then
    vim.diagnostic.jump { diagnostic = next }
  else
    vim.notify "No next diagnostic found"
  end
end

function M.diagnostic.go_to_prev()
  local prev = vim.diagnostic.get_prev()
  if prev ~= nil then
    vim.diagnostic.jump { diagnostic = prev }
  else
    vim.notify "No previous diagnostic found"
  end
end

-- H1: LSP
M.lsp = {}

function M.lsp.show_signature()
  vim.lsp.buf.signature_help()
end

function M.lsp.defintions()
  fzf.lsp_definitions()
end

function M.lsp.declarations()
  fzf.lsp_declarations()
end

function M.lsp.code_action()
  fzf.lsp_code_actions()
end

function M.lsp.references()
  fzf.lsp_references()
end

function M.lsp.implementations()
  fzf.lsp_implementations()
end

function M.lsp.type_definitions()
  fzf.lsp_type_definitions()
end

function M.lsp.document_symbols()
  fzf.lsp_document_symbols()
end

function M.lsp.live_workspace_symbols()
  fzf.lsp_live_workspace_symbols()
end

function M.lsp.restart_lsp()
  local attached_clients = vim.lsp.get_clients()
  if vim.tbl_isempty(attached_clients) then
    vim.notify("No active LSP clients found for the current buffer.", vim.log.levels.INFO)
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

-- H1: Refactoring
M.refactor = {}
function M.refactor.rename()
  vim.lsp.buf.rename()
end

function M.refactor.extract_func()
  return require("refactoring").refactor "Extract Function"
end

function M.refactor.extract_func_to_file()
  return require("refactoring").refactor "Extract Function To File"
end

function M.refactor.extract_var()
  return require("refactoring").refactor "Extract Variable"
end

function M.refactor.inline_func()
  return require("refactoring").refactor "Inline Function"
end

function M.refactor.inline_var()
  return require("refactoring").refactor "Inline Variable"
end

function M.refactor.extract_block()
  return require("refactoring").refactor "Extract Block"
end

function M.refactor.extract_block_to_file()
  return require("refactoring").refactor "Extract Block To File"
end

return M
