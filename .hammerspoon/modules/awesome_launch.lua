local M = {}

--- Try to launch an app if it's not already running
---@param appName string
---@return boolean success, hs.application|nil app
local function tryGetOrLaunchApp(appName)
    local app = hs.application.get(appName)
    if not app then
        print("App not found, launching")
        hs.application.launchOrFocus(appName)
        return true, nil
    end
    return false, app
end

--- Try to focus an existing window of the app in the current space
---@param app hs.application
---@return boolean success
local function tryFocusWindowInCurrentSpace(app)
    local currentSpace = hs.spaces.focusedSpace()
    local windows = app:allWindows()

    print("Windows: " .. #windows)
    for _, window in ipairs(windows) do
        print("Window: " .. window:title())
        local windowSpaces = hs.spaces.windowSpaces(window)
        if windowSpaces then
            for _, spaceId in ipairs(windowSpaces) do
                if spaceId == currentSpace then
                    print("App found on current space, focusing")
                    window:focus()
                    return true
                end
            end
        end
    end
    print("App not found on current space")
    return false
end

--- Get the dock's AXUIElement items
---@return table|nil items
local function getDockItems()
    local dock = hs.application.get("Dock")
    if not dock then
        print("Dock not found")
        return nil
    end

    local dockProcess = hs.axuielement.applicationElement(dock)
    local children = dockProcess:attributeValue("AXChildren")
    if children and #children > 0 then
        return children[1]
    end
    return nil
end

--- Try to open a new window from dock menu
---@param dockItem table
---@return boolean success
local function tryOpenNewWindowFromDock(dockItem)
    print("Found app in dock, opening new window in current space")
    dockItem:performAction("AXShowMenu")

    hs.timer.doAfter(0.1, function()
        local menu = dockItem:attributeValue("AXChildren")
        if menu and #menu > 0 then
            local menuItems = menu[1]:attributeValue("AXChildren")
            for _, menuItem in ipairs(menuItems) do
                local title = menuItem:attributeValue("AXTitle")
                if title == "New Window" then
                    menuItem:performAction("AXPress")
                    return
                end
            end
        end
    end)
    return true
end

--- Try to focus or open the app via the dock
---@param appName string
---@param newInCurrentSpace boolean|nil
---@return boolean success
local function tryOpenFromDock(appName, newInCurrentSpace)
    local items = getDockItems()
    if not items then
        return false
    end

    for _, item in ipairs(items) do
        print("Item: ", item:attributeValue("AXTitle"))
        if item:attributeValue("AXTitle") == appName then
            if newInCurrentSpace then
                return tryOpenNewWindowFromDock(item)
            end
            print("Found app in dock, focusing")
            item:performAction("AXPress")
            return true
        end
    end
    print("App not found in dock")
    return false
end

--- Try to activate app and focus its main window
---@param app hs.application
---@return boolean success
local function tryActivateAndFocusWindow(app)
    local testWindow = app:mainWindow()
    print("test window: ", testWindow)
    app:activate()
    
    hs.timer.doAfter(0.5, function()
        local appWindows = app:allWindows()
        print("App windows: " .. #appWindows)
        if #appWindows >= 1 then
            appWindows[1]:focus()
        end
    end)
    return true
end

--- Try to go to the space where the app has a visible window
---@param app hs.application
---@param appName string
---@return boolean success
local function tryGoToAppSpace(app, appName)
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
            return true
        end
    end
    return false
end

--- Launch or focus an application with smart window handling
---@param appName string The name of the application
---@param newInCurrentSpace boolean|nil If true, opens a new window in current space when app exists elsewhere
function M.launch(appName, newInCurrentSpace)
    -- If app is not found, launch it
    local launched, app = tryGetOrLaunchApp(appName)
    if launched then
        print("App launched")
        return
    end

    -- If app is found and on current space, focus it
    if tryFocusWindowInCurrentSpace(app) then
        print("App found on current space, focusing")
        return
    end

    -- Try to open/focus via dock
    if tryOpenFromDock(appName, newInCurrentSpace) then
        print("App found in dock, opening new window in current space")
        return
    end

    -- Fallback: activate and focus window
    if tryActivateAndFocusWindow(app) then
        print("App activated and focused window")
        return
    end

    -- Try going to the space where the app is
    if tryGoToAppSpace(app, appName) then
        print("App found on space, activating and focusing")
        return
    end

    print("App not found on current space")
end

return M

