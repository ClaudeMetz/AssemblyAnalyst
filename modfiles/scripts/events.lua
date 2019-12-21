script.on_init(function()
    global.zones = {}
end)


script.on_event(defines.events.on_player_selected_area, function(event)
    local player = game.get_player(event.player_index)

    if event.item == "aa-zone-selector" then
        handler.area_selected(player, event.area)
    end
end)


--[[ script.on_event(defines.events.on_player_alt_selected_area, function(event)
    local player = game.get_player(event.player_index)

end) ]]