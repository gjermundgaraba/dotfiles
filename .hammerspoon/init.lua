local spaces = require "modules.spaces"

-- TODO: See backlog in TODO.md

spaces.initSpacesBar()

-- Helper function to check windows and create new window if needed
local function checkWindowsAndCreateIfNeeded(app, appName)
    local currentSpace = hs.spaces.focusedSpace()
    local hasWindowOnCurrentSpace = false

    local appWindows = app:visibleWindows()
    for _, window in ipairs(appWindows) do
        local windowSpaces = hs.spaces.windowSpaces(window)
        if windowSpaces then
            for _, spaceId in ipairs(windowSpaces) do
                if spaceId == currentSpace then
                    print("Found existing window for " .. appName .. " on current space")
                    hasWindowOnCurrentSpace = true
                    window:focus()
                    return
                end
            end
        end
    end

    if not hasWindowOnCurrentSpace then
        print("No window on current space, creating new window")
        -- Ensure app is activated and frontmost
        app:activate(true)
        -- Wait for the app to be ready, then try to create a new window
        hs.timer.doAfter(1, function()
            -- Double-check the app is still frontmost
            local currentApp = hs.application.frontmostApplication()
            if currentApp and currentApp:bundleID() == app:bundleID() then
                -- Try using menu item first (more reliable than keyboard events)
                local success = app:selectMenuItem({ "File", "New Window" })
                if not success then
                    -- Fallback: try just "New Window" (some apps have it directly in File menu)
                    success = app:selectMenuItem("New Window")
                end
                if not success then
                    -- Final fallback: use keyboard shortcut
                    hs.eventtap.keyStroke({ "cmd" }, "n")
                end
            else
                -- If app lost focus, try activating again
                app:activate(true)
                hs.timer.doAfter(0.5, function()
                    local success = app:selectMenuItem({ "File", "New Window" })
                    if not success then
                        success = app:selectMenuItem("New Window")
                    end
                    if not success then
                        hs.eventtap.keyStroke({ "cmd" }, "n")
                    end
                end)
            end
        end)
    else
        print("Window on current space, focusing")
    end
end

-- newWindowIfNoneOnCurrentSpace: if true, a new window will be created if there is no window on the current space, without switching workspace (require auto-switch workspace to focused app to be turned off)
local function launchApp(appName, newWindowIfNoneOnCurrentSpace)
    if not newWindowIfNoneOnCurrentSpace then
        local app = hs.application.get(appName)
        if not app then
            hs.application.launchOrFocus(appName)
            return
        end

        local currentSpace = hs.spaces.focusedSpace()
        local appWindows = app:visibleWindows()
        for _, window in ipairs(appWindows) do
            local windowSpaces = hs.spaces.windowSpaces(window)
            if windowSpaces then
                for _, spaceId in ipairs(windowSpaces) do
                    if spaceId == currentSpace then
                        window:focus()
                        return
                    end
                end
            end
        end
    end

    -- Launch the app if it's not running
    local app = hs.application.get(appName)
    if not app then
        hs.application.launchOrFocus(appName)
        return
    end

    -- App exists, check windows immediately
    checkWindowsAndCreateIfNeeded(app, appName)
end

-- TODO: Add a launch or focus + move to the space where it is

hs.hotkey.bind({}, "F1", function()
    launchApp("Cursor", false)
end)

hs.hotkey.bind({}, "F2", function()
    launchApp("ChatGPT Atlas", false)
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

hs.hotkey.bind({}, "F12", function()
    launchApp("Ghostty", false)
    -- launchOrFocusOrNewWindow("Warp")
end)
