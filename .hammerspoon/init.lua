local spaces = require "modules.spaces"

-- TODO: See backlog in TODO.md

spaces.initSpacesBar()

hs.application.enableSpotlightForNameSearches(true) -- once is enough
-- TODO: Clean this function up
local function awesomeLaunch(appName)
    -- If app is not found, launch it
    local app = hs.application.get(appName)
    print("App: " .. app:name())
    if not app then
        print("App not found, launching")
        hs.application.launchOrFocus(appName)
        return
    end

    -- If app is found and on current space, focus it
    local currentSpace = hs.spaces.focusedSpace()
    local windows = app:allWindows()
    for _, window in ipairs(windows) do
        print("Window: " .. window:title())
        local windowSpaces = hs.spaces.windowSpaces(window)
        if windowSpaces then
            for _, spaceId in ipairs(windowSpaces) do
                if spaceId == currentSpace then
                    print("App found on current space, focusing")
                    window:focus()
                    return
                end
            end
        end
    end

    local dock = hs.application.get("Dock")
    if not dock then
        print("Dock not found, returning")
        return
    end

    local dockProcess = hs.axuielement.applicationElement(dock)
    local items = dockProcess:attributeValue("AXChildren")[1]

    for _, item in ipairs(items) do
        print("Item: ", item:attributeValue("AXTitle"))
        if item:attributeValue("AXTitle") == appName then
            print("Found app in dock, focusing")
            item:performAction("AXPress")
            return
        end
    end
    print("App not found in dock")


    local testWindow = app:mainWindow()
    print("test window: ", testWindow)
    app:activate()
    hs.timer.doAfter(0.5, function()
        local appWindows = app:allWindows()
        print("App windows: " .. #appWindows)
        if #appWindows >= 1 then
            appWindows[1]:focus()
            return
        end
    end)

    local appWindows = hs.window.filter.new(function(window) 
        print("Window: " .. window:title())
        return window:application():name() == appName and window:isVisible()
    end):getWindows()
    print("App windows: " .. #appWindows)
    if #appWindows >= 1 then
        local windowSpaces = hs.spaces.windowSpaces(appWindows[1])
        if windowSpaces and #windowSpaces >= 1 then
            hs.spaces.gotoSpace(windowSpaces[1])
            app:activate(true)
            return
        end
    end

    print("App not found on current space")
end

-- TODO: Add a launch or focus + move to the space where it is

hs.hotkey.bind({}, "F1", function()
    awesomeLaunch("Cursor")
end)

hs.hotkey.bind({}, "F2", function()
    awesomeLaunch("ChatGPT Atlas")
end)

hs.hotkey.bind({}, "F3", function()
    awesomeLaunch("Slack")
end)

hs.hotkey.bind({}, "F4", function()
    awesomeLaunch("Linear")
end)

hs.hotkey.bind({}, "F5", function()
    awesomeLaunch("Notion")
end)

hs.hotkey.bind({}, "F6", function()
    awesomeLaunch("ChatGPT")
end)

hs.hotkey.bind({}, "F7", function()
    awesomeLaunch("Obsidian")
end)

hs.hotkey.bind({}, "F8", function()
    awesomeLaunch("Superhuman")
end)

hs.hotkey.bind({}, "F9", function()
    awesomeLaunch("Notion Calendar")
end)

hs.hotkey.bind({}, "F12", function()
    awesomeLaunch("Ghostty")
end)
