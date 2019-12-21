-- This is a 'class' representing a specific area that is to be analysed
Zone = {}

function Zone.init(player, area)
    local zone = Zone
    zone.surface = player.surface
    zone.area = area
    zone.render_objects = {}

    zone:snap_to_grid()
    zone:redraw()
    
    return zone
end

-- Redraws everything related to the zone
function Zone:redraw()
    local border_id = self.render_objects.border
    if border_id then rendering.destroy(border_id) end
    self.render_objects.border = renderer.draw_zone_border(self)
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