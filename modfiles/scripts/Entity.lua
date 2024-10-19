-- This is a 'class' representing a specific entity
Entity = {}
Entity.__index = Entity

function Entity.init(object)
    local entity = {
        object = object,
        surface = object.surface,
        statusbar_area = nil,
        status_to_statistic = nil,
        statistics = DATA.statistics_template(),
        render_objects = {}  -- [statistic_name] = render_object
    }
    setmetatable(entity, Entity)

    entity:refresh_status_mapping()

    local collision_box = object.prototype.collision_box
    local entity_width = collision_box.right_bottom.x - collision_box.left_top.x
    local entity_height = collision_box.right_bottom.y - collision_box.left_top.y

    local usable_width = (object.type == "inserter") and 0.8 or (entity_width * 0.8)

    entity.statusbar_area = {
        left_top_offset = {- (usable_width / 2), (entity_height / 4)},
        usable_width = usable_width
    }

    return entity
end

function Entity:refresh_status_mapping()
    if not self.object.valid then return end
    local category = DATA.type_to_category[self.object.type]
    self.status_to_statistic = DATA.status_to_statistic[category]
end

function Entity:destroy_render_objects()
    for _, render_object in pairs(self.render_objects) do
        render_object.destroy()
    end
end


function Entity:redraw_statusbar()
    local statistics, total_datapoints = self.statistics, 0
    -- We do this accounting here to keep the on_tick size down
    for _, statistic in pairs(statistics) do total_datapoints = total_datapoints + statistic end
    if total_datapoints == 0 then return end

    local statusbar_area = self.statusbar_area
    local starting_left_top_offset = statusbar_area.left_top_offset
    local left_top_offset = {starting_left_top_offset[1], starting_left_top_offset[2]}
    local right_bottom_offset = {left_top_offset[1], left_top_offset[2] + 0.2}
    local usable_width = statusbar_area.usable_width

    local render_objects, entity = self.render_objects, self.object
    local colors = storage.settings.colors

    -- This 'abuses' the inherent order that Factorio lua pairs brings
    for statistic_name, _ in pairs(statistics) do
        local statistic = statistics[statistic_name]

        if statistic ~= 0 then
            local new_horizontal_offset = left_top_offset[1] + (usable_width * (statistic / total_datapoints))
            right_bottom_offset[1] = new_horizontal_offset

            local render_object = render_objects[statistic_name]
            local color = colors[statistic_name]

            if render_object then
                render_object.set_corners({entity=entity, offset=left_top_offset},
                    {entity=entity, offset=right_bottom_offset})
                render_object.color = color
            else
                render_objects[statistic_name] = rendering.draw_rectangle{
                    left_top=self.object, left_top_offset=left_top_offset,
                    right_bottom=self.object, right_bottom_offset=right_bottom_offset,
                    surface=self.surface, filled=true, color=color
                }
            end

            left_top_offset[1] = new_horizontal_offset
        end
    end
end
