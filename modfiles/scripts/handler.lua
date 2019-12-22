handler = {}

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

    global.zones[global.zone_running_index] = new_zone
    global.zone_running_index = global.zone_running_index + 1
end

-- Removes all zones that overlap with the given area
function handler.area_alt_selected(player, area)
    remove_overlaps{surface = player.surface, area = area}
end