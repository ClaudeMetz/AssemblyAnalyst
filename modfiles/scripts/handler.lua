handler = {}

-- Reloads the current settings to the global table
function handler.reload_settings()
    global.settings = {
        ["magnetic-selection"] = settings.global["aa-magnetic-selection"].value,
        ["reset-data-on-change"] = settings.global["aa-reset-data-on-change"].value
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
    local new_zone = Zone.init(player, area, entities)

    -- If zone creation fails, abort here
    if new_zone == nil then return end

    remove_overlaps{zone = new_zone}

    new_zone.index = global.zone_running_index
    global.zones[global.zone_running_index] = new_zone
    global.zone_running_index = global.zone_running_index + 1
end

-- Removes all zones that overlap with the given area
function handler.area_alt_selected(player, area)
    remove_overlaps{surface = player.surface, area = area}
end


-- Handles a relevant entity being built, adding it to a zone if applicable
function handler.entity_built(entity)
    if entity.type == "entity-ghost" then return end

    -- Determine actual entity area
    local collision_box, position = entity.prototype.collision_box, entity.position
    local spec = {
        surface = entity.surface,
        area = {
            left_top = {
                x = position.x + collision_box.left_top.x,
                y = position.y + collision_box.left_top.y
            },
            right_bottom = {
                x = position.x + collision_box.right_bottom.x,
                y = position.y + collision_box.right_bottom.y
            }
        }
    }

    -- Check if it overlaps with any of the active zones
    for _, zone in pairs(global.zones) do
        if zone:overlaps_with(spec) then
            zone.entity_map[entity.unit_number] = entity
            zone:revalidate(true)
            break
        end
    end
end


-- Runs the on_tick refresh of every relevant entity
function handler.on_tick()
    for _, zone in pairs(global.zones) do
        if not zone:revalidate(false) then break end

        zone.observe_schedule:tick()
        zone.redraw_schedule:tick()
    end
end