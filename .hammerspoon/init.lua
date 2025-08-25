local function launchOrFocusOrNewWindow(appName)
	local app = hs.application.get(appName)

	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	local currentSpace = hs.spaces.focusedSpace()
	local appWindows = app:visibleWindows()

	for _, window in ipairs(appWindows) do
		local windowSpaces = hs.spaces.windowSpaces(window)
		for _, spaceId in ipairs(windowSpaces) do
			if spaceId == currentSpace then
				window:focus()
				return
			end
		end
	end

	app:activate()
	
	hs.timer.waitUntil(
		function() return app:isFrontmost() end,
		function()
			local newWindows = app:visibleWindows()
			local hasNewWindow = false
			
			for _, window in ipairs(newWindows) do
				local windowSpaces = hs.spaces.windowSpaces(window)
				for _, spaceId in ipairs(windowSpaces) do
					if spaceId == currentSpace then
						hasNewWindow = true
						break
					end
				end
				if hasNewWindow then break end
			end
			
			if not hasNewWindow then
				hs.eventtap.keyStroke({"cmd"}, "n")
			end
		end,
		0.01
	)
end

hs.hotkey.bind({}, "F1", function()
	launchOrFocusOrNewWindow("Cursor")
end)

hs.hotkey.bind({}, "F2", function()
	launchOrFocusOrNewWindow("Comet")
end)

hs.hotkey.bind({}, "F3", function()
	hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind({}, "F4", function()
	launchOrFocusOrNewWindow("Linear")
end)

hs.hotkey.bind({}, "F5", function()
	launchOrFocusOrNewWindow("Notion")
end)

hs.hotkey.bind({}, "F6", function()
	launchOrFocusOrNewWindow("ChatGPT")
end)

hs.hotkey.bind({}, "F7", function()
	launchOrFocusOrNewWindow("Obsidian")
end)

hs.hotkey.bind({}, "F8", function()
	launchOrFocusOrNewWindow("Superhuman")
end)

hs.hotkey.bind({}, "F9", function()
	launchOrFocusOrNewWindow("Notion Calendar")
end)

hs.hotkey.bind({}, "F10", function()
	launchOrFocusOrNewWindow("Todoist")
end)

hs.hotkey.bind({}, "F12", function()
	launchOrFocusOrNewWindow("Warp")
end)
