--pcall(require,'__debugadapter__/debugadapter.lua')

math2d = require("math2d")  -- base game lualib

require("scripts.Zone")
require("scripts.Schedule")

require("scripts.maps")
require("scripts.events")
require("scripts.handler")
require("scripts.updater")

devmode = true  -- Enables certain conveniences for development

if devmode then
    Profiler = require("lualib.profiler")
    require("lualib.llog")
end