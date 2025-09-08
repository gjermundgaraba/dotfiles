package.cpath = package.cpath .. ";" ..
    os.getenv("HOME") .. "/.local/share/sketchybar_lua/?.so"
local sbar = require("sketchybar")

-- Kick off monitor resolution at startup
local monitors = require("helpers.monitors")
monitors.start()

sbar.begin_config()
-- sbar.hotload(true)

require("bar")
require("default")
require("items")

sbar.end_config()
sbar.event_loop()
