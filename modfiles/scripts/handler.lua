handler = {}

function handler.area_selected(player, area)
    local new_zone = Zone.init(player, area)

    table.insert(global.zones, new_zone)
end