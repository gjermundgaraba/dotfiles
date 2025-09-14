local sbar = require("sketchybar")
local colors = require("colors").sections.spaces
local app_icons = require("helpers.app_icons")
local settings = require("settings")
local monitors = require("helpers.monitors")
local env = require("helpers.env")
local WL = require("helpers.workspace_labels")
local MAIN_DISPLAY = env.main_display_id()

-- Check if this workspace is currently focused
local function is_focused_workspace(space_name, callback)
	sbar.exec("aerospace list-workspaces --focused", function(focused)
		local current = focused:match("^%s*(.-)%s*$")
		callback(current == space_name)
	end)
end

-- Add app icons and hide if empty + unfocused
local function add_windows(space, space_name)
	sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
		local icon_line = ""
		for app in windows:gmatch("[^\r\n]+") do
			local icon = app_icons[app] or app_icons["Default"]
			icon_line = icon_line .. " " .. icon
		end

		local label_text = icon_line == "" and "—" or icon_line
		local padding = icon_line == "" and 8 or 12

		sbar.animate("tanh", 10, function()
			space:set({
				label = {
					string = label_text,
					padding_right = padding,
				},
			})
		end)
	end)
end

sbar.exec("aerospace list-workspaces --all", function(output)
	for space_name in output:gmatch("[^\r\n]+") do
		local is_first = space_name == "1"

local space = sbar.add("item", "space." .. space_name, {
			associated_display = MAIN_DISPLAY,
			display = MAIN_DISPLAY,
icon = {
				string = WL.format_display(space_name),
				color = colors.icon.color,
				highlight_color = colors.icon.highlight,
				padding_left = 8,
			},
			label = {
				font = "sketchybar-app-font:Regular:14.0",
				string = "",
				color = colors.label.color,
				highlight_color = colors.label.highlight,
				y_offset = -1,
			},
			click_script = "aerospace workspace " .. space_name,
			padding_left = is_first and 0 or 4,
			drawing = true,
		})

add_windows(space, space_name)

		-- Refresh icon text when labels change
		space:subscribe(WL.event, function()
			WL.reload()
			space:set({
				icon = { string = WL.format_display(space_name) },
			})
		end)

		space:subscribe("aerospace_workspace_change", function(env)
			local selected = env.FOCUSED_WORKSPACE == space_name
			space:set({
				icon = { highlight = selected },
				label = { highlight = selected },
			})

			if selected then
				sbar.animate("tanh", 8, function()
					space:set({
						background = { shadow = { distance = 0 } },
						y_offset = -4,
						padding_left = 8,
						padding_right = 0,
					})
					space:set({
						background = { shadow = { distance = 4 } },
						y_offset = 0,
						padding_left = 4,
						padding_right = 4,
					})
				end)
			end

			space:set({ drawing = true })
			add_windows(space, space_name)
		end)

		space:subscribe("space_windows_change", function()
			add_windows(space, space_name)
		end)

		space:subscribe("mouse.clicked", function()
			sbar.animate("tanh", 8, function()
				space:set({
					background = { shadow = { distance = 0 } },
					y_offset = -4,
					padding_left = 8,
					padding_right = 0,
				})
				space:set({
					background = { shadow = { distance = 4 } },
					y_offset = 0,
					padding_left = 4,
					padding_right = 4,
				})
			end)
		end)
	end
end)

-- Side displays: add a single-workspace item per configured display (UUID only)
local function add_single_space_item_by_uuid(display_uuid, workspace, name_suffix)
	local display_id = monitors.get_display_id_by_uuid(display_uuid)
	if not (display_id and workspace) then return end
	local item_name = ("space.%s.%s"):format(workspace, name_suffix)
local space = sbar.add("item", item_name, {
		associated_display = display_id,
		display = display_id,
icon = { string = WL.format_display(workspace), color = colors.icon.color, highlight_color = colors.icon.highlight, padding_left = 8 },
		label = { font = "sketchybar-app-font:Regular:14.0", string = "", color = colors.label.color, highlight_color = colors.label.highlight, y_offset = -1 },
		click_script = "aerospace workspace " .. workspace,
		padding_left = 4,
		drawing = true,
	})
add_windows(space, workspace)
-- Refresh icon text when labels change (side display item)
space:subscribe(WL.event, function()
	WL.reload()
	space:set({ icon = { string = WL.format_display(workspace) } })
end)
space:subscribe("aerospace_workspace_change", function(env)
		local selected = (env.FOCUSED_WORKSPACE == workspace)
		space:set({ icon = { highlight = selected }, label = { highlight = selected } })
		add_windows(space, workspace)
	end)
	space:subscribe("space_windows_change", function()
		add_windows(space, workspace)
	end)
	space:subscribe("mouse.clicked", function()
		sbar.animate("tanh", 8, function()
			space:set({ background = { shadow = { distance = 0 } }, y_offset = -4, padding_left = 8, padding_right = 0 })
			space:set({ background = { shadow = { distance = 4 } }, y_offset = 0, padding_left = 4, padding_right = 4 })
		end)
	end)
end

local uuid_map = settings.monitors.workspace_by_display_uuid or {}
for uuid, workspace in pairs(uuid_map) do
	local display_id = monitors.get_display_id_by_uuid(uuid)
	if display_id and display_id ~= MAIN_DISPLAY then
		local suffix = (uuid:gsub("-", "")):sub(1, 6)
		add_single_space_item_by_uuid(uuid, workspace, suffix)
	end
end
