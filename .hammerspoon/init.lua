local function launchOrFocusOrNewWindow(appName)
	local app = hs.application.get(appName)

	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	local currentSpace = hs.spaces.focusedSpace()
	local appWindows = app:visibleWindows()
	local hasWindowOnCurrentSpace = false

	for _, window in ipairs(appWindows) do
		local windowSpaces = hs.spaces.windowSpaces(window)
		for _, spaceId in ipairs(windowSpaces) do
			if spaceId == currentSpace then
				hasWindowOnCurrentSpace = true
				window:focus()
				return
			end
		end
	end

	if not hasWindowOnCurrentSpace then
		app:activate()
		hs.timer.doAfter(0.1, function()
			hs.eventtap.keyStroke({ "cmd" }, "n")
		end)
	end
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
	hs.application.launchOrFocus("Linear")
end)

hs.hotkey.bind({}, "F5", function()
	hs.application.launchOrFocus("Notion")
end)

hs.hotkey.bind({}, "F6", function()
	hs.application.launchOrFocus("ChatGPT")
end)

hs.hotkey.bind({}, "F7", function()
	hs.application.launchOrFocus("Obsidian")
end)

hs.hotkey.bind({}, "F8", function()
	hs.application.launchOrFocus("Superhuman")
end)

hs.hotkey.bind({}, "F9", function()
	hs.application.launchOrFocus("Notion Calendar")
end)

hs.hotkey.bind({}, "F10", function()
	hs.application.launchOrFocus("Todoist")
end)

hs.hotkey.bind({}, "F12", function()
	launchOrFocusOrNewWindow("Warp")
end)
