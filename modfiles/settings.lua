data:extend{
    {
        type = "bool-setting",
        name = "aa-magnetic-selection",
        setting_type = "runtime-global",
        default_value = true,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "aa-resnap-zone-on-change",
        setting_type = "runtime-global",
        default_value = true,
        order = "b"
    },
    {
        type = "bool-setting",
        name = "aa-reset-data-on-change",
        setting_type = "runtime-global",
        default_value = false,
        order = "c"
    },
    {
        type = "bool-setting",
        name = "aa-exclude-inserters",
        setting_type = "runtime-global",
        default_value = false,
        order = "d"
    }
}

local status_types = {
    working = {0, 135, 0},
    output_overload = {102, 224, 0},
    input_shortage = {255, 165, 0},
    insufficient_power = {204, 0, 0},
    disabled = {204, 0, 204}
}

-- The order matters here, but pairs handles it correctly in Factorio Lua
local index = 1
for type, default_color in pairs(status_types) do
    data:extend{
        {
            type = "color-setting",
            name = "aa-status-color-" .. type,
            setting_type = "runtime-global",
            default_value = default_color,
            order = "z-" .. index
        }
    }
    index = index + 1
end
