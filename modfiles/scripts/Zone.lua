-- This is a 'class' representing a specific area that is to be analysed
Zone = {}
Zone.__index = Zone

function Zone.init(player, area, entities)
    local zone = {
        index = nil,
        surface = player.surface,
        area = area,
        entity_map = {},
        entity_data = nil,
        observe_schedule = nil,
        redraw_schedule = nil,
        render_objects = { entities = {} }
    }
    setmetatable(zone, Zone)
    
    -- Make sure that the zone is 2-dimensional, else cancel the init process
    local left_top, right_bottom = area.left_top, area.right_bottom
    if left_top.x > right_bottom.x and left_top.y < right_bottom.y then return nil end

    for _, entity in pairs(entities) do zone.entity_map[entity.unit_number] = entity end
    zone:reset_entity_data()

    zone.observe_schedule = Schedule.init(zone, "observe", 1)
    zone.redraw_schedule = Schedule.init(zone, "redraw", 60)

    zone:magnetic_snap()
    zone:snap_to_grid()
    zone:redraw_border()
    
    return zone
end

function Zone:destroy()
    rendering.destroy(self.render_objects.border)

    for unit_number, _ in pairs(self.entity_map) do
        self:remove_render_objects(unit_number)
    end
end


-- Removes any entities that have become invalid, refresh optionally
function Zone:revalidate(force_refresh)
    -- Remove zone if its surface has become invalid
    if not self.surface.valid then
        self:destroy()
        global.zones[self.index] = nil
        return false
    end
    
    local entity_removed = false
    for unit_number, entity in pairs(self.entity_map) do
        if not entity.valid then
            self.entity_map[unit_number] = nil
            entity_removed = true
        end
    end
    if entity_removed or force_refresh then self:refresh() end
    
    return true
end

-- Refreshes this area and schedule
function Zone:refresh()
    if self:magnetic_snap() then
        self:snap_to_grid()
        self:redraw_border()
    end

    self.observe_schedule:reset()
    self.redraw_schedule:reset()
    if global.settings["reset-data-on-change"] then self:reset_entity_data() end
end

-- Resets any entity data that has been collected
function Zone:reset_entity_data()
    self.entity_data = {}
    for unit_number, entity in pairs(self.entity_map) do
        self.entity_data[unit_number] = entity_type_map[entity.type].data_init()
    end
end

-- Removes all render_objects associated to the given unit_number
function Zone:remove_render_objects(unit_number)
    local render_objects = self.render_objects.entities
    local entity_render_objects = render_objects[unit_number]
    
    if entity_render_objects ~= nil then
        for _, render_object_id in pairs(entity_render_objects) do
            rendering.destroy(render_object_id)
        end
    end

    render_objects[unit_number] = {}
    return render_objects[unit_number]
end


-- Adjusts the zone to fit snugly around it's entities, if the setting is active
function Zone:magnetic_snap()
    if global.settings["magnetic-selection"] and table_size(self.entity_map) > 0 then
        local min_x, max_x, min_y, max_y
        
        for _, entity in pairs(self.entity_map) do
            local position = entity.position
            local x_position, y_position = position.x, position.y
            local collision_box = entity.prototype.collision_box
            
            min_x = math.min((min_x or x_position), (x_position + collision_box.left_top.x))
            max_x = math.max((max_x or x_position), (x_position + collision_box.right_bottom.x))
            min_y = math.min((min_y or y_position), (y_position + collision_box.left_top.y))
            max_y = math.max((max_y or y_position), (y_position + collision_box.right_bottom.y))
        end
        
        local left_top, right_bottom = self.area.left_top, self.area.right_bottom
        left_top.x, right_bottom.x, left_top.y, right_bottom.y = min_x, max_x, min_y, max_y

        return true
    end
    return false
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
    local border = self.render_objects.border
    if border ~= nil then rendering.destroy(border) end

    local border_color = { r = 0, g = 0.75, b = 1 }
    self.render_objects.border = rendering.draw_rectangle{surface=self.surface, left_top=self.area.left_top, right_bottom=self.area.right_bottom, filled=false, width=4, color=border_color, draw_on_ground=true}
end


-- Returns whether the given zone-spec overlaps with this one (Specified by a zone object or a surface and an area)
function Zone:overlaps_with(spec)
    local surface_name = (spec.zone) and spec.zone.surface.name or spec.surface.name
    local area = (spec.zone) and spec.zone.area or spec.area
    return (self.surface.name == surface_name and math2d.bounding_box.collides_with(self.area, area))
end