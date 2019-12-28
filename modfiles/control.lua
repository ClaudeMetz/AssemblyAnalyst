--pcall(require,'__debugadapter__/debugadapter.lua')

math2d = require("math2d")  -- base game lualib

require("scripts.data")
require("scripts.handler")
require("scripts.events")

require("scripts.Zone")
require("scripts.Schedule")
require("scripts.Entity")

devmode = true  -- Enables certain conveniences for development
redraw_cycle_rate = 90

if devmode then
    Profiler = require("lualib.profiler")
    require("lualib.llog")
end