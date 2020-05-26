-- This is a 'class' representing a specific entity
Entity = {}
Entity.__index = Entity

function Entity.init(object)
    local entity = {
        object = object,
        surface = object.surface.name,
        statusbar_area = nil,
        status_to_statistic = nil,
        statistics = data.statistics_template(),
        render_objects = {}
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

function Entity:destroy()
    for _, render_object_id in pairs(self.render_objects) do
        rendering.destroy(render_object_id)
    end
    return self.render_objects
end


function Entity:redraw_statusbar()
    local render_objects = self:destroy()

    local statusbar_area = self.statusbar_area
    local left_top = {x = statusbar_area.left_top.x, y = statusbar_area.left_top.y}
    local right_bottom, usable_width = statusbar_area.right_bottom, statusbar_area.usable_width

    local statistics, total_datapoints = self.statistics, 0
    for _, statistic in pairs(statistics) do total_datapoints = total_datapoints + statistic end
    if total_datapoints == 0 then return end

    for _, render_parameter in ipairs(data.render_parameters) do
        local statistic = statistics[render_parameter.name]
        local width = usable_width * (statistic / total_datapoints)
        
        if width ~= 0 then
            table.insert(render_objects, rendering.draw_rectangle{surface=self.surface, left_top=left_top,  right_bottom=right_bottom, filled=true, color=render_parameter.color})

            left_top.x = (left_top.x + width)
        end
    end
end