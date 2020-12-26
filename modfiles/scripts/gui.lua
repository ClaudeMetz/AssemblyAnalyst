gui = {}

function gui.show_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]

    if info_window == nil then
        info_window = player.gui.screen.add{type="frame", name="aa-frame-legend",
          caption={"aa-gui.legend"}, direction="vertical"}
        local content_frame = info_window.add{type="frame", direction="vertical",
          style="inside_shallow_frame_with_padding"}
        local table_legend = content_frame.add{type="table", column_count=2}
        table_legend.style.horizontal_spacing = 12
        table_legend.style.column_alignments[1] = "middle-right"

        -- This 'abuses' the inherent order that Factorio lua pairs brings
        for status_type, _ in pairs(DATA.statistics_template()) do
            local color = global.settings.colors[status_type]
            table_legend.add{type="label", caption={"aa-gui.legend_color", color.r, color.g, color.b}}
            table_legend.add{type="label", caption={"aa-gui." .. status_type .. "_name"}}
        end

        local window_height, tool_window_height = 192, 92  -- easier to just hardcode it
        info_window.location = {x = 5, y = player.display_resolution.height - window_height - tool_window_height - 10}
    else
        info_window.visible = true
    end
end

function gui.hide_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]
    if info_window ~= nil then info_window.visible = false end
end

function gui.rebuild_all()
    for _, player in pairs(game.players) do
        local info_window = player.gui.screen["aa-frame-legend"]
        if info_window ~= nil then
            local visibility = info_window.visible
            info_window.destroy()
            gui.show_info_window(player)
            player.gui.screen["aa-frame-legend"].visible = visibility
        end
    end
end