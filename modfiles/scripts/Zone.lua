-- This is a 'class' representing a specific area that is to be analysed
Zone = {}
Zone.__index = Zone

function Zone.init(player, area, entities)
    local zone = {
        surface = player.surface,
        area = area,
        entity_map = {},
        render_objects = {}
    }
    setmetatable(zone, Zone)
    
    -- Make sure that the zone is 2-dimensional, else cancel the init process
    local left_top, right_bottom = area.left_top, area.right_bottom
    if left_top.x > right_bottom.x and left_top.y < right_bottom.y then return nil end

    for _, entity in pairs(entities) do zone.entity_map[entity.unit_number] = entity end

    zone:magnetic_snap()
    zone:snap_to_grid()

    zone:redraw()
    
    return zone
end

-- Runs cleanup before this zone can be dereferenced
function Zone:destroy()
    for _, render_object_id in pairs(self.render_objects) do
        rendering.destroy(render_object_id)
    end
end


-- Redraws everything related to the zone
function Zone:redraw()
    local border_id = self.render_objects.border
    if border_id then rendering.destroy(border_id) end
    self.render_objects.border = renderer.draw_zone_border(self)
end


-- Adjusts the zone to fit snugly around it's entities, if the setting is active
function Zone:magnetic_snap()
    if settings.global["aa-magnetic-selection"].value == true and table_size(self.entity_map) > 0 then
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


-- Returns whether the given zone-spec overlaps with this one
-- (Either specified by a zone object or a surface and an area)
function Zone:overlaps_with(spec)
    local surface_name = (spec.zone) and spec.zone.surface.name or spec.surface.name
    local area = (spec.zone) and spec.zone.area or spec.area
    return (self.surface.name == surface_name and math2d.bounding_box.collides_with(self.area, area))
end