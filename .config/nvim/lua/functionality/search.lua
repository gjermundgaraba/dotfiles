local M = {}

function M.file_picker()
  Snacks.picker.files { hidden = true }
end

function M.grep()
  Snacks.picker.grep { hidden = true }
end

function M.grep_plugin_files()
  Snacks.picker.grep {
    dirs = { vim.fs.joinpath(vim.fn.stdpath "data", "lazy") },
  }
end

return M
