local M = {}

-- Sometimes nice to have as a little debug function
function M.print_file_type_on_attach()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      -- Just to avoid recursive notifications
      if vim.bo.filetype == "snacks_notif" then
        return
      end

      vim.notify(vim.bo.filetype)
    end,
  })
end

return M
