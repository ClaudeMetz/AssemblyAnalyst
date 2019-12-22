--pcall(require,'__debugadapter__/debugadapter.lua')

math2d = require("math2d")  -- base game lualib

require("scripts.Zone")
require("scripts.Schedule")

require("scripts.events")
require("scripts.handler")

require("scripts.types.assembler")

devmode = true  -- Enables certain conveniences for development

if devmode then
    Profiler = require("lualib.profiler")
    require("lualib.llog")
end

entity_type_map = {
    ["assembling-machine"] = assembler,
    ["rocket-silo"] = assembler,
    ["furnace"] = assembler
}