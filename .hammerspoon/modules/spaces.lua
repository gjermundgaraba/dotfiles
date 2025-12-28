local M = {}

function M.initSpacesBar()
    local mainScreen = hs.screen.mainScreen()
    local screenSpaces = hs.spaces.spacesForScreen(mainScreen)
    if not screenSpaces or #screenSpaces == 0 then
        hs.alert.show("No spaces found for the main screen.")
        return
    end

    M.spacesBySpaceID = {}
    M.spacesByIndex = {}
    for index, spaceID in ipairs(screenSpaces) do
        local space = {
            id = spaceID,
            index = index,
            label = ""
        }
        M.spacesBySpaceID[spaceID] = space
        M.spacesByIndex[index] = space
    end

    local menubar = hs.menubar.new()
    if not menubar then
        hs.alert.show("Failed to create menubar item.")
        return
    end

    M.menubar = menubar

    hs.spaces.watcher.new(function()
        M.updateSpacesMenubar()
    end):start()

    M.menubar:setClickCallback(function(modifier)
        if modifier.alt then
            local focusedSpaceID = hs.spaces.focusedSpace()
            local focusedSpace = M.spacesBySpaceID[focusedSpaceID]
            focusedSpace.label = ""
            M.updateSpacesMenubar()
            return
        end
        local hammerspoonApp = hs.application.get("Hammerspoon")
        local wasManagedKeyboard = nil
        if hammerspoonApp then
            wasManagedKeyboard = hammerspoonApp:isFrontmost()
            hammerspoonApp:activate(true)
        end

        local clicked, newSpaceName = hs.dialog.textPrompt(
            "Set space name",
            "Enter a new name for the current space:",
            "",
            "OK",
            "Cancel"
        )

        if hammerspoonApp and not wasManagedKeyboard then
            hammerspoonApp:hide()
        end

        if clicked == "OK" and newSpaceName and newSpaceName ~= "" then
            local focusedSpaceID = hs.spaces.focusedSpace()
            local focusedSpace = M.spacesBySpaceID[focusedSpaceID]
            if focusedSpace then
                focusedSpace.label = newSpaceName
                M.updateSpacesMenubar()
            end
        end
    end)

    hs.socket.udp.server(42069, function(data, addr)
        print("server")
        -- remove any trailing newlines
        local newLabel = data:gsub("\n$", "")

        if newLabel == "" then
            return
        end

        local focusedSpaceID = hs.spaces.focusedSpace()
        local focusedSpace = M.spacesBySpaceID[focusedSpaceID]
        focusedSpace.label = newLabel
        M.updateSpacesMenubar()
    end):receive()

    -- initial update
    M.updateSpacesMenubar()
end

function M.updateSpacesMenubar()
    local focusedSpaceID = hs.spaces.focusedSpace()
    local focusedSpace = M.spacesBySpaceID[focusedSpaceID]

    local label = focusedSpace.label
    local title = "🖥️ " .. tostring(focusedSpace.index)
    if label ~= "" then
        title = "🖥️ " .. label
    end

    M.menubar:setTitle(title)
end

return M

