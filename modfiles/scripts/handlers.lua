handlers = {}

local default_status_colors = {
    working = "#008700",
    output_overload = "#66e000",
    input_shortage = "#ffa500",
    insufficient_power = "#cc0000",
    disabled = "#cc00cc"
}

function handlers.reload_settings()
    global.settings = {
        ["magnetic-selection"] = settings.global["aa-magnetic-selection"].value,
        ["resnap-zone-on-change"] = settings.global["aa-resnap-zone-on-change"].value,
        ["reset-data-on-change"] = settings.global["aa-reset-data-on-change"].value,
        ["exclude-inserters"] = settings.global["aa-exclude-inserters"].value,
        ["render-scale-exponent"] = 1.0 / settings.global["aa-render-scale"].value,
    }

    global.settings.colors = {}
    -- This 'abuses' the inherent order that Factorio lua pairs brings
    for status_type, _ in pairs(DATA.statistics_template()) do
        local hex_color = settings.global["aa-status-color-" .. status_type].value

        if not string.find(hex_color, "^#?[0-9a-f]+$") then
            hex_color = default_status_colors[status_type]
        end

        global.settings.colors[status_type] = hex_to_rgb(hex_color)
    end
end


local function remove_overlapping_zones(surface, area)
    local zones = global.zones
    for index, zone in pairs(zones) do
        if zone:overlaps_with(surface, area, nil) then
            zone:destroy_render_objects()
            zones[index] = nil
        end
    end
end

-- Handles creating a new zone and dealing with overlaps
function handlers.area_selected(player, area, entities)
    local new_zone = Zone.init(player.surface, area, entities)
    -- If zone creation fails, abort here
    if new_zone == nil then return end

    remove_overlapping_zones(player.surface, area)

    new_zone.index = global.zone_running_index
    global.zones[global.zone_running_index] = new_zone
    global.zone_running_index = global.zone_running_index + 1

    gui.refresh_all()
end

-- Removes all zones that overlap with the given area
function handlers.area_alt_selected(player, area)
    remove_overlapping_zones(player.surface, area)
    gui.refresh_all()
end


-- Handles a relevant entity being built, adding it to a zone if applicable
function handlers.entity_built(event)
    local new_entity = event.created_entity or event.entity

    if new_entity.type == "entity-ghost" or not Zone.allow_analysis(new_entity) then return end

    -- Check if it overlaps with any of the active zones
    for _, zone in pairs(global.zones) do
        if zone:overlaps_with(new_entity.surface, nil, new_entity) then
            local entity_map = zone.entity_map
            entity_map[new_entity.unit_number] = Entity.init(new_entity)

            -- This might have been a replacement, so revalidate everything
            -- Even if it wasn't, revalidate in case the tick is paused
            for unit_number, entity in pairs(entity_map) do
                if not entity.object.valid then entity_map[unit_number] = nil end
            end

            zone:refresh()
            break
        end
    end
end

-- Collects statistics and redraws certain statusbars
function handlers.on_tick()
    -- The surface will always be valid because invalid ones are immediately removed
    for _, zone in pairs(global.zones) do
        local entity_removed = false

        for unit_number, entity in pairs(zone.entity_map) do
            local object = entity.object

            if not object.valid then
                zone.entity_map[unit_number] = nil
                entity_removed = true
            else
                local statistic_id = entity.status_to_statistic[object.status]
                assert(statistic_id, "unhandled entity status '" .. object.status ..
                    "' for entity type '" .. object.type .. "'")
                local statistics = entity.statistics
                statistics[statistic_id] = statistics[statistic_id] + 1
            end
        end

        if entity_removed then zone:refresh() end
        zone.redraw_schedule:tick()
    end
end
