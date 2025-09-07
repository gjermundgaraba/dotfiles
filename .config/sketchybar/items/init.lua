local sbar = require("sketchybar")

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
sbar.add("bracket", { "widgets.volume", "widgets.battery" }, {})
