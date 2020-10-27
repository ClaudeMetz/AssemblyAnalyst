gui = {}

function gui.show_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]

    if info_window == nil then
        info_window = player.gui.screen.add{type="frame", name="aa-frame-legend",
          caption={"aa-gui.assembly_analyst"}, direction="vertical"}
        local content_frame = info_window.add{type="frame", direction="vertical",
          style="inside_shallow_frame_with_padding"}
        local table_legend = content_frame.add{type="table", column_count=2}
        table_legend.style.horizontal_spacing = 12
        table_legend.style.column_alignments[1] = "middle-right"

        for _, render_parameter in ipairs(DATA.render_parameters) do
            local name, color = render_parameter.name, render_parameter.color
            table_legend.add{type="label", caption={"aa-gui.legend_color", color[1], color[2], color[3],
              {"aa-gui." .. name .. "_color_name"}}}
            table_legend.add{type="label", caption={"aa-gui." .. name .. "_name"}}
        end

        info_window.location = {x = 5, y = player.display_resolution.height - (260 * player.display_scale)}
    else
        info_window.visible = true
    end
end

function gui.hide_info_window(player)
    local info_window = player.gui.screen["aa-frame-legend"]
    if info_window ~= nil then info_window.visible = false end
end