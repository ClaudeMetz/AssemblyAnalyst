-- This is a 'class' representing a specific entity
Entity = {}
Entity.__index = Entity

function Entity.init(object)
    local entity = {
        object = object,
        surface = object.surface,
        statusbar_area = nil,
        status_to_statistic = nil,
        statistics = data.statistics_template(),
        render_objects = {}  -- [statistic_name] = render_object_id
    }
    setmetatable(entity, Entity)

    local category = data.type_to_category[object.type]
    entity.status_to_statistic = data.status_to_statistic[category]

    local entity_area = util.determine_entity_area(object)

    if object.type == "inserter" then  -- Enlarge statusbar for inserters
        entity_area.left_top.x = entity_area.left_top.x - 0.25
        entity_area.right_bottom.x = entity_area.right_bottom.x + 0.25
    end

    local bottom_offset = (entity_area.right_bottom.y - entity_area.left_top.y) / 5
    entity_area.left_top.y = entity_area.right_bottom.y - bottom_offset - 0.2
    entity_area.right_bottom.y = entity_area.right_bottom.y - bottom_offset

    entity_area.usable_width = entity_area.right_bottom.x - entity_area.left_top.x
    entity.statusbar_area = entity_area

    return entity
end

function Entity:destroy_render_objects()
    for _, render_object_id in pairs(self.render_objects) do
        rendering.destroy(render_object_id)
    end
end


function Entity:redraw_statusbar()
    local statistics, total_datapoints = self.statistics, 0
    -- We do this accounting here to keep the on_tick size down
    for _, statistic in pairs(statistics) do total_datapoints = total_datapoints + statistic end
    if total_datapoints == 0 then return end

    local statusbar_area = self.statusbar_area
    local left_top = {x = statusbar_area.left_top.x, y = statusbar_area.left_top.y}
    local right_bottom = {x = statusbar_area.right_bottom.x, y = statusbar_area.right_bottom.y}
    local usable_width = statusbar_area.usable_width

    local render_objects, null_offset = self.render_objects, {0, 0}
    for _, render_parameter in ipairs(data.render_parameters) do
        local statistic_name = render_parameter.name
        local statistic = statistics[statistic_name]

        if statistic ~= 0 then
            local draw_to_x = left_top.x + (usable_width * (statistic / total_datapoints))
            right_bottom.x = draw_to_x

            local render_object_id = render_objects[statistic_name]
            if render_object_id then
                rendering.set_corners(render_object_id, left_top, null_offset, right_bottom, null_offset)
            else
                render_objects[statistic_name] = rendering.draw_rectangle{surface=self.surface, left_top=left_top,
                  right_bottom=right_bottom, filled=true, color=render_parameter.color}
            end

            left_top.x = draw_to_x
        end
    end
end