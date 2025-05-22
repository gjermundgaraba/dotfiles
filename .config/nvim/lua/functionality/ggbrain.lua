local M = {}

local async = require "plenary.async"
local backlinks = require "obsidian.commands.backlinks"
local follow_link = require "obsidian.commands.follow_link"
local n = require "nui-components"
local quick_switch = require "obsidian.commands.quick_switch"
local search = require "obsidian.commands.search"
local template = require "obsidian.commands.template"

local input = async.wrap(function(prompt, text, completion, callback)
  vim.ui.input({
    prompt = prompt,
    default = text,
    completion = completion,
  }, callback)
end, 4)

---@class obsidian.Client
local client = require("obsidian").get_client()

function M.todos()
  local work_todos_note = client:resolve_note "TODO"
  local work_todos_path = work_todos_note.path.filename
  local personal_todos_note = client:resolve_note "Personal TODO"
  local personal_todos_path = personal_todos_note.path.filename

  local work_todos_buf = vim.fn.bufadd(work_todos_path)
  vim.fn.bufload(work_todos_buf)
  local personal_todos_buf = vim.fn.bufadd(personal_todos_path)
  vim.fn.bufload(personal_todos_buf)

  local renderer = n.create_renderer {
    width = 200,
    height = 60,
  }
  local body = function()
    return n.columns(
      { flex = 0 },
      n.buffer {
        id = "work_todos",
        flex = 1,
        buf = work_todos_buf,
        autofocus = true,
        border_label = "Work TODOs",
      },
      n.buffer {
        id = "personal_todos",
        flex = 1,
        buf = personal_todos_buf,
        border_label = "Personal TODOs",
      }
    )
  end

  renderer:add_mappings {
    {
      mode = { "n" },
      key = "<C-h>",
      handler = function()
        local left = renderer:get_component_by_direction "left"
        if left then
          left:focus()
        end
      end,
    },
    {
      mode = { "n" },
      key = "<C-l>",
      handler = function()
        local right = renderer:get_component_by_direction "right"
        if right then
          right:focus()
        end
      end,
    },
  }

  renderer:on_unmount(function()
    vim.api.nvim_buf_call(work_todos_buf, function()
      vim.cmd "write"
    end)

    vim.api.nvim_buf_call(personal_todos_buf, function()
      vim.cmd "write"
    end)
    -- close the buffers
    vim.api.nvim_buf_delete(work_todos_buf, { force = false })
    vim.api.nvim_buf_delete(personal_todos_buf, { force = false })
  end)

  renderer:render(body)
end

function M.open_index()
  quick_switch(client, { args = "index" })
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
    quick_switch(client, { args = title })
  end)()
end

function M.find_note()
  quick_switch(client, { args = "" })
end

function M.search()
  search(client, { args = "" })
end

function M.show_backlinks()
  backlinks(client)
end

function M.follow_link()
  -- TODO: Replace with requires
  follow_link(client, {})
end

function M.insert_template()
  -- TODO: Replace with requires
  template(client, {})
end

return M
