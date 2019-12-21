handler = {}

-- Handles creating a new zone and dealing with overlaps
function handler.area_selected(player, area)
    local new_zone = Zone.init(player, area)

    for index, zone in pairs(global.zones) do
        if new_zone:overlaps_with(zone) then
            zone:destroy()
            global.zones[index] = nil
        end
    end

    global.zones[global.current_zone_index] = new_zone
    global.current_zone_index = global.current_zone_index + 1
end