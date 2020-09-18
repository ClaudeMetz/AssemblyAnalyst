handler = {}

-- Reloads the current settings to the global table
function handler.reload_settings()
    global.settings = {
        ["magnetic-selection"] = settings.global["aa-magnetic-selection"].value,
        ["resnap-zone-on-change"] = settings.global["aa-resnap-zone-on-change"].value,
        ["reset-data-on-change"] = settings.global["aa-reset-data-on-change"].value,
        ["exclude-inserters"] = settings.global["aa-exclude-inserters"].value
    }
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
function handler.area_selected(player, area, entities)
    local new_zone = Zone.init(player.surface, area, entities)
    -- If zone creation fails, abort here
    if new_zone == nil then return end

    remove_overlapping_zones(player.surface, area)

    new_zone.index = global.zone_running_index
    global.zones[global.zone_running_index] = new_zone
    global.zone_running_index = global.zone_running_index + 1
end

-- Removes all zones that overlap with the given area
function handler.area_alt_selected(player, area)
    remove_overlapping_zones(player.surface, area)
end


-- Handles a relevant entity being built, adding it to a zone if applicable
function handler.entity_built(event)
    local new_entity = event.created_entity or event.entity
    if new_entity.type == "entity-ghost" then return end
    if global.settings["exclude-inserters"] and new_entity.type == "inserter" then return end
    if string.find(new_entity.name, "miniloader%-inserter$") then return end

    -- Check if it overlaps with any of the active zones
    for _, zone in pairs(global.zones) do
        if zone:overlaps_with(new_entity.surface, nil, new_entity) then
            local entity_map = zone.entity_map
            entity_map[new_entity.unit_number] = Entity.init(new_entity)

            -- This might have been a replacement, so revalidate everything
            for unit_number, entity in pairs(entity_map) do
                if not entity.object.valid then
                    entity_map[unit_number] = nil
                    break  -- only one entity could have been replaced
                end
            end

            zone:refresh()
            break
        end
    end
end

-- Collects statistics and redraws certain statusbars
function handler.on_tick()
    for zone_index, zone in pairs(global.zones) do
        if not zone.surface.valid then
            global.zones[zone_index] = nil
        else
            local entity_removed = false
            for unit_number, entity in pairs(zone.entity_map) do
                local object = entity.object

                if not object.valid then
                    zone.entity_map[unit_number] = nil
                    entity_removed = true
                else
                    local statistic_id = entity.status_to_statistic[object.status]
                    local statistics = entity.statistics
                    statistics[statistic_id] = statistics[statistic_id] + 1
                end
            end

            if entity_removed then zone:refresh() end
            zone.redraw_schedule:tick()
        end
    end
end