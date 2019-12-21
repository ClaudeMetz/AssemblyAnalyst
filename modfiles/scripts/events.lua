script.on_init(function()
    global.zones = {}
    global.current_zone_index = 1
end)

script.on_load(function()
    for _, zone in pairs(global.zones) do
        setmetatable(zone, Zone)
    end
end)


script.on_event(defines.events.on_player_selected_area, function(event)
    local player = game.get_player(event.player_index)

    if event.item == "aa-zone-selector" then
        handler.area_selected(player, event.area, event.entities)
    end
end)


script.on_event(defines.events.on_player_alt_selected_area, function(event)
    local player = game.get_player(event.player_index)

    if event.item == "aa-zone-selector" then
        handler.area_alt_selected(player, event.area)
    end
end)