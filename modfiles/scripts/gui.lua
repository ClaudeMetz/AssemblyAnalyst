gui = {}

local function determine_entity_count()
    local entity_count = 0
    for _, zone in pairs(storage.zones) do
        entity_count = entity_count + zone.entity_count
    end
    return entity_count
end

function gui.show_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]

    if info_window ~= nil then
        info_window.visible = true
    else
        info_window = player.gui.screen.add{type="frame", name="aa-frame-legend",
          caption={"aa-gui.legend"}, direction="vertical"}
        local content_frame = info_window.add{type="frame", name="content_frame", direction="vertical",
          style="inside_shallow_frame_with_padding"}
        local table_legend = content_frame.add{type="table", column_count=2}
        table_legend.style.horizontal_spacing = 12
        table_legend.style.column_alignments[1] = "middle-right"

        -- This 'abuses' the inherent order that Factorio lua pairs brings
        for status_type, _ in pairs(DATA.statistics_template()) do
            local color = storage.settings.colors[status_type]
            table_legend.add{type="label", caption={"aa-gui.legend_color", color.r, color.g, color.b}}
            table_legend.add{type="label", caption={"aa-gui." .. status_type .. "_name"}}
        end

        local line = content_frame.add{type="line", direction="horizontal"}
        line.style.margin = 8

        content_frame.add{type="label", name="entities_tracked_label"}
        gui.refresh_info_window(player, nil)  -- hereafter done on demand when the count changes

        local window_height, tool_window_height = 232, 92  -- easier to just hardcode it
        local offset = (window_height + tool_window_height + 10) * player.display_scale
        info_window.location = {x = 5, y = (player.display_resolution.height - offset)}
    end

end

function gui.hide_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]
    if info_window ~= nil then info_window.visible = false end
end

function gui.refresh_info_window(player, entity_count)
    local info_window = player.gui.screen["aa-frame-legend"]
    if not info_window then return end

    entity_count = entity_count or determine_entity_count()
    local label_tracked = info_window["content_frame"]["entities_tracked_label"]
    label_tracked.caption = {"aa-gui.entities_tracked", entity_count}
end

function gui.refresh_all()
    -- Determine the entity count once for performance reasons
    local entity_count = determine_entity_count()
    for _, player in pairs(game.players) do
        gui.refresh_info_window(player, entity_count)
    end
end

function gui.rebuild_all()
    for _, player in pairs(game.players) do
        local info_window = player.gui.screen["aa-frame-legend"]
        if info_window ~= nil then
            local visibility = info_window.visible
            info_window.destroy()
            gui.show_info_window(player)  -- builds it anew
            player.gui.screen["aa-frame-legend"].visible = visibility
        end
    end
end
