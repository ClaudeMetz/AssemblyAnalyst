math2d = require("math2d")  -- base game lualib

require("scripts.Zone")
require("scripts.renderer")
require("scripts.events")
require("scripts.handler")

devmode = true  -- Enables certain conveniences for development

if devmode then
    Profiler = require("lualib.profiler")
    require("lualib.llog")
end