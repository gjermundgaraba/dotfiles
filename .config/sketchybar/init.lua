package.cpath = package.cpath .. ";" ..
    os.getenv("HOME") .. "/.local/share/sketchybar_lua/?.so"
local sbar = require("sketchybar")

sbar.begin_config()
sbar.hotload(true)

require("bar")
require("default")
require("items")

sbar.end_config()
sbar.event_loop()
