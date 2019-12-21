renderer = {}

-- Draws the border of the zone specified by the given area
function renderer.draw_zone_border(zone)
    local border_color = { r = 0, g = 0.75, b = 1 }
    return rendering.draw_rectangle{surface=zone.surface, left_top=zone.area.left_top, right_bottom=zone.area.right_bottom, filled=false, width=4, color=border_color, draw_on_ground=true}
end