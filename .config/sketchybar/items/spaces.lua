local sbar = require("sketchybar")
local colors = require("colors").sections.spaces
local app_icons = require("helpers.app_icons")

-- Check if this workspace is currently focused
local function is_focused_workspace(space_name, callback)
	sbar.exec("aerospace list-workspaces --focused", function(focused)
		local current = focused:match("^%s*(.-)%s*$")
		callback(current == space_name)
	end)
end

-- Add app icons and hide if empty + unfocused
local function add_windows(space, space_name)
	print("Updating windows for space " .. space_name)
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

		-- Auto-hide if empty and not focused
		-- is_focused_workspace(space_name, function(is_focused)
		-- 	local should_draw = icon_line ~= "" or is_focused
		-- 	print("Setting drawing for space " .. space_name .. " to " .. tostring(should_draw))
		-- 	space:set({ drawing = should_draw })
		-- end)
	end)
end

sbar.exec("aerospace list-workspaces --all", function(output)
	for space_name in output:gmatch("[^\r\n]+") do
		local is_first = space_name == "1"

		local space = sbar.add("item", "space." .. space_name, {
			icon = {
				string = space_name,
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
			drawing = true, -- hide by default until checked
		})

		add_windows(space, space_name)

		space:subscribe("aerospace_workspace_change", function(env)
			local selected = env.FOCUSED_WORKSPACE == space_name
			print("Workspace " .. space_name .. " selected: " .. tostring(selected))
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

			-- Always make focused space visible
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
