-- This is a 'class' representing a specific area that is to be analysed
Zone = {}
Zone.__index = Zone

function Zone.init(surface, area, entities)
    local zone = {
        surface = surface,
        area = area,

        entity_map = {},
        entity_count = 0,

        render_objects = {},   -- just contains `border`

        cycles = nil
    }
    setmetatable(zone, Zone)

    for _, entity in pairs(entities) do
        zone.entity_map[entity.unit_number] = Entity.init(entity)
        zone.entity_count = zone.entity_count + 1
    end

    if storage.settings["magnetic-selection"] then zone:magnetic_snap() end
    zone:snap_to_grid()

    -- Make sure that the zone is 2-dimensional, else cancel the init process
    local left_top, right_bottom = area.left_top, area.right_bottom
    if left_top.x == right_bottom.x or left_top.y == right_bottom.y then return nil end

    zone:reset_cycle()  -- initializes cycle data
    zone:redraw_border()

    return zone
end


function Zone:refresh_status_mapping()
    for _, entity in pairs(self.entity_map) do
        entity:refresh_status_mapping()
    end
end

function Zone:destroy_render_objects()
    self.render_objects.border.destroy()
    for _, entity in pairs(self.entity_map) do entity:destroy_render_objects() end
end


-- Refreshes this area and cycle
function Zone:refresh()
    if storage.settings["resnap-zone-on-change"] then
        self:magnetic_snap()
        self:snap_to_grid()
        self:redraw_border()
    end

    self:reset_cycle()

    if storage.settings["reset-data-on-change"] then
        for _, entity in pairs(self.entity_map) do
            entity:reset_statistics()
        end
    end

    self.entity_count = table_size(self.entity_map)  -- this is slow, but easy
    gui.refresh_all()
end


-- Adjusts the zone to fit snugly around it's entities, if the setting is active
function Zone:magnetic_snap()
    if table_size(self.entity_map) > 0 then
        local min_x, max_x, min_y, max_y

        for _, entity in pairs(self.entity_map) do
            local position = entity.object.position
            local x_position, y_position = position.x, position.y
            local collision_box = entity.object.prototype.collision_box

            min_x = math.min((min_x or x_position), (x_position + collision_box.left_top.x))
            max_x = math.max((max_x or x_position), (x_position + collision_box.right_bottom.x))
            min_y = math.min((min_y or y_position), (y_position + collision_box.left_top.y))
            max_y = math.max((max_y or y_position), (y_position + collision_box.right_bottom.y))
        end

        local left_top, right_bottom = self.area.left_top, self.area.right_bottom
        left_top.x, right_bottom.x, left_top.y, right_bottom.y = min_x, max_x, min_y, max_y
    end
end

-- Adjusts the area of the zone to the nearest tile borders
function Zone:snap_to_grid()
    local left_top = self.area.left_top
    left_top.x = math.floor(left_top.x+0.5)
    left_top.y = math.floor(left_top.y+0.5)

    local right_bottom = self.area.right_bottom
    right_bottom.x = math.floor(right_bottom.x+0.5)
    right_bottom.y = math.floor(right_bottom.y+0.5)
end


function Zone:redraw_border()
    local border_color = { r = 0, g = 0.75, b = 1 }
    local border_object = self.render_objects.border

    if border_object ~= nil then
        border_object.set_corners(self.area.left_top, self.area.right_bottom)
    else
        self.render_objects.border = rendering.draw_rectangle{surface=self.surface,
          left_top=self.area.left_top, right_bottom=self.area.right_bottom, filled=false, width=4,
          color=border_color, draw_on_ground=true}
    end
end


local function determine_entity_area(entity)
    local collision_box, position = entity.prototype.collision_box, entity.position
    return {
        left_top = {
            x = position.x + collision_box.left_top.x,
            y = position.y + collision_box.left_top.y
        },
        right_bottom = {
            x = position.x + collision_box.right_bottom.x,
            y = position.y + collision_box.right_bottom.y
        }
    }
end

function Zone:overlaps_with(surface, area, entity)
    if area == nil then area = determine_entity_area(entity) end
    return (self.surface.name == surface.name and collides_with(self.area, area))
end



-- Resets the cycle, incorporating the current entity_map
function Zone:reset_cycle()
    self.cycles = {}

    local entity_map = self.entity_map
    local actions_per_cycle = math.ceil(table_size(entity_map) / REDRAW_CYCLE_RATE)
    local this_cycle, actions_this_cycle = 1, 0

    for _, entity in pairs(entity_map) do
        self.cycles[this_cycle] = self.cycles[this_cycle] or {}
        table.insert(self.cycles[this_cycle], entity)

        actions_this_cycle = actions_this_cycle + 1
        if actions_this_cycle == actions_per_cycle then
            this_cycle = this_cycle + 1
            actions_this_cycle = 0
        end
    end
end

function Zone:tick(cycle)
    for _, entity in pairs(cycle) do
        entity:cycle_statistics()
        entity:redraw_statusbar()
    end
end
