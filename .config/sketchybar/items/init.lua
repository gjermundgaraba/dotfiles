local sbar = require("sketchybar")
local settings = require("settings")
local monitors = require("helpers.monitors")
local MAIN_DISPLAY = monitors.get_main_display_id(settings.monitors.main_uuid)

--left
require("items.apple")
require("items.spaces")

--center
require("items.notifications")

--right (reverse order)
require("items.calendar")
require("items.widgets")
require("items.wifi")
require("items.media")

-- Group visible widgets explicitly once they exist (exclude the spacer)
sbar.add("bracket", { "widgets.volume", "widgets.battery" }, { associated_display = MAIN_DISPLAY, display = MAIN_DISPLAY })
