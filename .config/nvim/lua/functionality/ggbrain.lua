local M = {}

local async = require "plenary.async"

local input = async.wrap(function(prompt, text, completion, callback)
  vim.ui.input({
    prompt = prompt,
    default = text,
    completion = completion,
  }, callback)
end, 4)

---@class obsidian.Client
local client = require("obsidian").get_client()

function M.open_index()
  client:command("ObsidianQuickSwitch", { args = "index" })
end

function M.new_note()
  async.void(function()
    local title = input("Title: ", "", nil)
    if not title then
      return
    end

    client:create_note {
      id = title,
      title = title,
    }

    local index_note = client:resolve_note "index"
    index_note:save {
      update_content = function(lines)
        for i, line in ipairs(lines) do
          if line == "-- ggbrain:unsorted:above --" then
            table.insert(lines, i, "- [[" .. title .. "]]")
            break
          end
        end
        return lines
      end,
    }

    client:command("ObsidianQuickSwitch", { args = title })
  end)()
end

function M.search()
  client:command "ObsidianSearch"
end

function M.show_backlinks()
  client:command "ObsidianBacklinks"
end

function M.follow_link()
  client:command "ObsidianFollowLink"
end

function M.insert_template()
  client:command "ObsidianTemplate"
end

return M
