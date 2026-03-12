local spaces = require "modules.spaces"
local awesomeLaunch = require "modules.awesome_launch"

-- TODO: See backlog in TODO.md

-- spaces.initSpacesBar()

hs.application.enableSpotlightForNameSearches(true) -- once is enough

-- TODO: Add a launch or focus + move to the space where it is

hs.hotkey.bind({}, "F1", function()
    awesomeLaunch.launch("Cursor", true)
end)

hs.hotkey.bind({}, "F2", function()
    awesomeLaunch.launch("ChatGPT Atlas", true)
end)

hs.hotkey.bind({}, "F3", function()
    awesomeLaunch.launch("Slack")
end)

hs.hotkey.bind({}, "F4", function()
    awesomeLaunch.launch("Linear")
end)

hs.hotkey.bind({}, "F5", function()
    awesomeLaunch.launch("gg")
end)

hs.hotkey.bind({}, "F6", function()
    awesomeLaunch.launch("ChatGPT")
end)

hs.hotkey.bind({}, "F7", function()
    awesomeLaunch.launch("Todoist")
end)

hs.hotkey.bind({}, "F12", function()
    awesomeLaunch.launch("Ghostty", true)
end)
