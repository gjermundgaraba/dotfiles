vim.lsp.enable {
  'gopls',
  'codelldb',
  'jsonls',
  'stylua',
  'lua_ls',
  'solidity_ls',
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('gg-lsp-attach', { clear = true }),
  callback = function(event)
    -- it sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<C-s>', vim.lsp.buf.signature_help, 'Signature help', { 'i', 'n' })

    -- Jumpy jumps (gotos)
    -- To jump back, either press <C-t> (tag stack) or <C-o> (jump list).
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('gt', require('telescope.builtin').lsp_type_definitions, 'Variable [T]ype Definition') -- variable type (definition of its *type*, not where it was *defined*)
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gf', '[m', 'Jump to start of [f]unction')
    map('gF', '[M', 'Jump to end of [f]unction')

    -- Fuzzy fuzzs
    map('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols') -- Symbols are things like variables, functions, types, etc.
    map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('gg-lsp-highlight', { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('gg-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'gg-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle [L]SP Inlay [H]ints')
    end
  end,
})
