-- This is a 'class' representing a specific entity
Entity = {}
Entity.__index = Entity

function Entity.init(object)
    local entity = {
        object = object,
        surface = object.surface,

        statusbar_area = nil,  -- determined below
        render_objects = {},  -- [statistic_name] = render_object

        status_to_statistic = nil,

        statistics_blocks = nil,
        newest_block = nil,
        oldest_block = nil,

        running_total = nil,
        total_datapoints = nil
    }
    setmetatable(entity, Entity)

    local collision_box = object.prototype.collision_box
    local entity_width = collision_box.right_bottom.x - collision_box.left_top.x
    local entity_height = collision_box.right_bottom.y - collision_box.left_top.y

    local usable_width = (object.type == "inserter") and 0.8 or (entity_width * 0.8)

    entity.statusbar_area = {
        left_top_offset = {- (usable_width / 2), (entity_height / 4)},
        usable_width = usable_width
    }

    entity:refresh_status_mapping()  -- initializes status_to_statistic
    entity:reset_statistics()  -- initializes statistics data

    return entity
end


function Entity:refresh_status_mapping()
    if not self.object.valid then return end
    local category = DATA.type_to_category[self.object.type]
    self.status_to_statistic = DATA.status_to_statistic[category]
end

function Entity:reset_statistics()
    self.statistics_blocks = {DATA.statistics_template()}
    self.newest_block, self.oldest_block = 1, 1
    self.running_total = DATA.statistics_template()
    self.total_datapoints = 0
end

function Entity:destroy_render_objects()
    for _, render_object in pairs(self.render_objects) do
        render_object.destroy()
    end
end


function Entity:add_statistics(block, multiplier)
    for statistic_name, statistic in pairs(block) do
        self.running_total[statistic_name] = self.running_total[statistic_name] + (statistic * multiplier)
        self.total_datapoints = self.total_datapoints + (statistic * multiplier)
    end
end

function Entity:cycle_statistics()
    self:add_statistics(self.statistics_blocks[self.newest_block], 1)

    self.newest_block = self.newest_block + 1
    self.statistics_blocks[self.newest_block] = DATA.statistics_template()

    if self.newest_block - self.oldest_block > (STATISTICS_WINDOW_SIZE / REDRAW_CYCLE_RATE) then
        self:add_statistics(self.statistics_blocks[self.oldest_block], -1)

        self.statistics_blocks[self.oldest_block] = nil
        self.oldest_block = self.oldest_block + 1
    end
end


function Entity:redraw_statusbar()
    local total_datapoints = self.total_datapoints
    if total_datapoints == 0 then return end

    local statusbar_area = self.statusbar_area
    local starting_left_top_offset = statusbar_area.left_top_offset
    local left_top_offset = {starting_left_top_offset[1], starting_left_top_offset[2]}
    local right_bottom_offset = {left_top_offset[1], left_top_offset[2] + 0.2}
    local usable_width = statusbar_area.usable_width

    local render_objects, entity = self.render_objects, self.object
    local colors = storage.settings.colors

    -- This 'abuses' the inherent order that Factorio Lua pairs brings
    for statistic_name, statistic in pairs(self.running_total) do
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
