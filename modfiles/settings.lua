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
    working = "#008700",
    output_overload = "#66e000",
    input_shortage = "#ffa500",
    insufficient_power = "#cc0000",
    disabled = "#cc00cc"
}

-- The order matters here, but pairs handles it correctly in Factorio lua
local index = 1
for type, default_color in pairs(status_types) do
    data:extend{
        {
            type = "string-setting",
            name = "aa-status-color-" .. type,
            setting_type = "runtime-global",
            default_value = default_color,
            order = "z-" .. index
        }
    }
    index = index + 1
end
