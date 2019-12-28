handler = {}

-- Reloads the current settings to the global table
function handler.reload_settings()
    global.settings = {
        ["magnetic-selection"] = settings.global["aa-magnetic-selection"].value,
        ["reset-data-on-change"] = settings.global["aa-reset-data-on-change"].value
    }
end

-- Determines the actual area an entity takes up
function handler.determine_entity_area(entity)
    local collision_box, position = entity.prototype.collision_box, entity.position
    return {
        left_top = {
            x = position.x + collision_box.left_top.x,
            y = position.y + collision_box.left_top.y
        },
        right_bottom = {
            x = position.x + collision_box.right_bottom.x,
            y = position.y + collision_box.right_bottom.y
        }
    }
end


-- Removes all zones that overlap with the given area
local function remove_overlaps(spec)
    local zones = global.zones
    for index, zone in pairs(zones) do
        if zone:overlaps_with(spec) then
            zone:destroy()
            zones[index] = nil
        end
    end
end

-- Handles creating a new zone and dealing with overlaps
function handler.area_selected(player, area, entities)
    remove_overlaps{surface = player.surface, area = area}
    
    local new_zone = Zone.init(player.surface, area, entities)
    -- If zone creation fails, abort here
    if new_zone == nil then return end

    new_zone.index = global.zone_running_index
    global.zones[global.zone_running_index] = new_zone
    global.zone_running_index = global.zone_running_index + 1
end

-- Removes all zones that overlap with the given area
function handler.area_alt_selected(player, area)
    remove_overlaps{surface = player.surface, area = area}
end


-- Handles a relevant entity being built, adding it to a zone if applicable
function handler.entity_built(event)
    local entity = event.created_entity or event.entity
    if entity.type == "entity-ghost" then return end

    -- Determine actual entity area
    local spec = {
        surface = entity.surface,
        area = handler.determine_entity_area(entity)
    }

    -- Check if it overlaps with any of the active zones
    for _, zone in pairs(global.zones) do
        if zone:overlaps_with(spec) then
            local entity_map = zone.entity_map
            entity_map[entity.unit_number] = Entity.init(entity)

            -- This might have been a replacement, so revalidate everything
            for unit_number, entity in pairs(entity_map) do
                if not entity.object.valid then
                    entity:destroy()
                    entity_map[unit_number] = nil
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
            zone:destroy()
            global.zones[zone_index] = nil
        else
            local entity_removed = false
            for unit_number, entity in pairs(zone.entity_map) do
                local object = entity.object

                if not object.valid then
                    entity:destroy()
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