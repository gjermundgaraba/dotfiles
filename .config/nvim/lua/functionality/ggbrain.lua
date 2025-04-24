local M = {}

---@class obsidian.Client
local client = require("obsidian").get_client()

function M.open_index()
  client:command("ObsidianQuickSwitch", { args = "index" })
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
