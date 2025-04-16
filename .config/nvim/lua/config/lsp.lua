vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("gg-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, "Toggle [L]SP Inlay [H]ints")
    end

    map("<C-s>", vim.lsp.buf.signature_help, "Signature help", { "i", "n" })
    map("gf", "[m", "Jump to start of [f]unction")
    map("gF", "[M", "Jump to end of [f]unction")

    map("<leader>lr", function()
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
    end, "LSP [R]estart")

    -- The rest is set in snacks.lua

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("gg-lsp-highlight", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("gg-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "gg-lsp-highlight", buffer = event2.buf }
        end,
      })
    end
  end,
})
