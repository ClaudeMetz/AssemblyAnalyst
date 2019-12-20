local zone_selector_entity_filters = {"inserter"}

data:extend({
    {
        -- Zone-selector
        type = "selection-tool",
        name = "aa_zone_selector",
        stack_size = 1,
        show_in_library = false,
        flags = {"hidden", "not-stackable", "only-in-cursor"},
        subgroup = "other",
        order = "aa-a[zone-selector]",
        icon = "__assemblyanalyst__/graphics/tool-zone-selector.png",
        icon_size = 32,

        selection_color = { r = 0, g = 0.75, b = 1 },
        selection_mode = {"entity-with-health"},
        selection_cursor_box_type = "electricity",
        entity_filter_mode = "whitelist",
        entity_type_filters = zone_selector_entity_filters,
        
        alt_selection_color = { r = 0.9, g = 0.15, b = 0 },
        alt_selection_mode = {"entity-with-health"},
        alt_selection_cursor_box_type = "not-allowed",
        alt_entity_filter_mode = "whitelist",
        alt_entity_type_filters = zone_selector_entity_filters
    },

    {
        -- Keyboard shortcut for the zone-selector
        type = "custom-input",
        name = "aa_select_zone",
        key_sequence = "CONTROL + Z",
        action = "create-blueprint-item",
        item_to_create = "aa_zone_selector",
        consuming = "all",
        order = "a"
    },

    {
        -- Quickbar shortcut for the zone-selector
        type = "shortcut",
        name = "aa_select_zone",
        action = "create-blueprint-item",
        item_to_create = "aa_zone_selector",
        associated_control_input = "aa_select_zone",
        order = "aa-a[select-zone]",
        icon =
        {
            filename = "__assemblyanalyst__/graphics/shortcut-zone-selector-black-32.png",
            flags = {"icon"},
            size = 32,
        },
        small_icon =
        {
            filename = "__assemblyanalyst__/graphics/shortcut-zone-selector-black-24.png",
            flags = {"icon"},
            size = 24
        },
        disabled_small_icon =
        {
            filename = "__assemblyanalyst__/graphics/shortcut-zone-selector-white-24.png",
            flags = {"icon"},
            size = 24
        }
    },
})