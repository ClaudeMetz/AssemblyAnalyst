script.on_init(function()
    global.zones = {}
    global.zone_running_index = 1
    handler.reload_settings()
end)

script.on_load(function()
    for _, zone in pairs(global.zones) do
        setmetatable(zone, Zone)
        setmetatable(zone.redraw_schedule, Schedule)
        for _, entity in pairs(zone.entity_map) do setmetatable(entity, Entity) end
    end
end)


script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    if event.setting_type == "runtime-global" then handler.reload_settings() end
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


script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, handler.entity_built)

script.on_event(defines.events.script_raised_built, function(event)
    if data.type_to_category[entity.type] ~= nil then handler.entity_built(event) end
end)


script.on_event(defines.events.on_tick, handler.on_tick)