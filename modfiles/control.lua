math2d = require("math2d")  -- base game lualib

require("scripts.data")
require("scripts.handler")
require("scripts.events")
require("scripts.gui")
require("scripts.util")

require("scripts.Zone")
require("scripts.Schedule")
require("scripts.Entity")

--devmode = true  -- Enables certain conveniences for development
redraw_cycle_rate = 120

if devmode then
    require("lualib.llog")
    llog_excludes = {}
end