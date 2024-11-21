local zone_selector_entity_filters = {"assembling-machine", "rocket-silo", "furnace", "lab", "mining-drill", "inserter"}

data:extend({
    {
        -- Zone-selector
        type = "selection-tool",
        name = "aa-zone-selector",
        stack_size = 1,
        hidden = true,
        flags = {"spawnable", "not-stackable", "only-in-cursor"},
        subgroup = "other",
        order = "aa-a[zone-selector]",
        icon = "__assemblyanalyst__/graphics/tool-zone-selector.png",
        icon_size = 32,
        select = {
            mode = "entity-with-health",
            border_color = { r = 0, g = 0.75, b = 1 },
            cursor_box_type = "electricity",
            entity_filter_mode = "whitelist",
            entity_type_filters = zone_selector_entity_filters
        },
        alt_select = {
            -- The alt mode is set to nothing so you don't get the impression that
            -- you can exclude individual entities from the selection
            mode = "nothing",
            border_color = { r = 0.9, g = 0.15, b = 0 },
            cursor_box_type = "not-allowed",
            entity_filter_mode = "whitelist",
            entity_type_filters = zone_selector_entity_filters
        }
    },

    {
        -- Keyboard shortcut for the zone-selector
        type = "custom-input",
        name = "aa-select-zone",
        key_sequence = "ALT + Z",
        action = "spawn-item",
        item_to_spawn = "aa-zone-selector",
        consuming = "game-only",
        order = "a"
    },
    {
        -- Keyboard shortcut to clear all zones
        type = "custom-input",
        name = "aa-clear-zones",
        key_sequence = "CONTROL + ALT + C",
        consuming = "game-only",
        order = "b"
    },

    {
        -- Quickbar shortcut for the zone-selector
        type = "shortcut",
        name = "aa-select-zone",
        action = "spawn-item",
        item_to_spawn = "aa-zone-selector",
        associated_control_input = "aa-select-zone",
        order = "aa-a[select-zone]",
        icon = "__assemblyanalyst__/graphics/shortcut-zone-selector-x56.png",
        icon_size = 56,
        small_icon = "__assemblyanalyst__/graphics/shortcut-zone-selector-x24.png",
        small_icon_size = 24
    },

    -- Tips and Tricks
    {
        type = "tips-and-tricks-item-category",
        name = "assembly-analyst",
        order = "z"
    },
    {
        type = "tips-and-tricks-item",
        name = "aa-introduction",
        category = "assembly-analyst",
        starting_status = "unlocked",
        is_title = true,
        image = "__assemblyanalyst__/graphics/tips-and-tricks/introduction.png",
        order = "a"
    },
    {
        type = "tips-and-tricks-item",
        name = "aa-how-to-get-started",
        category = "assembly-analyst",
        starting_status = "unlocked",
        indent = 1,
        image = "__assemblyanalyst__/graphics/tips-and-tricks/how-to-get-started.png",
        order = "b"
    },
    {
        type = "tips-and-tricks-item",
        name = "aa-selection-tool",
        category = "assembly-analyst",
        starting_status = "unlocked",
        indent = 1,
        image = "__assemblyanalyst__/graphics/tips-and-tricks/selection-tool.png",
        order = "c"
    },
    {
        type = "tips-and-tricks-item",
        name = "aa-entity-status",
        category = "assembly-analyst",
        starting_status = "unlocked",
        indent = 1,
        image = "__assemblyanalyst__/graphics/tips-and-tricks/entity-status.png",
        order = "d"
    },
    {
        type = "tips-and-tricks-item",
        name = "aa-mod-settings",
        category = "assembly-analyst",
        starting_status = "unlocked",
        indent = 1,
        image = "__assemblyanalyst__/graphics/tips-and-tricks/mod-settings.png",
        order = "e"
    }
})
