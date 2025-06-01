local M = {}

local fzf = require "fzf-lua"

function M.file_picker()
  fzf.files()
end

function M.open_buffers()
  fzf.buffers()
end

function M.resume()
  fzf.resume()
end

function M.recent_files()
  fzf.oldfiles {
    cwd_only = true,
  }
end

function M.live_grep()
  fzf.live_grep()
end

function M.live_grep_in_directory(dir)
  fzf.live_grep {
    search_paths = { dir },
    winopts = {
      title = "Grep: " .. dir,
    },
  }
end

function M.grep_plugin_files()
  fzf.live_grep {
    search_paths = { vim.fn.stdpath "data" .. "/lazy" },
  }
end

function M.help()
  fzf.help_tags()
end

function M.git_branches()
  fzf.git_branches()
end

function M.git_blame()
  fzf.git_blame()
end

function M.git_log()
  fzf.git_commits()
end

function M.git_diff()
  fzf.git_diff()
end

return M
